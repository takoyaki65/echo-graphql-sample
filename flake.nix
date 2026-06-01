{
  description = "Development shell for an Echo + gqlgen GraphQL sample";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
    let
      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              go
              gopls
              gotools
              go-tools
              golangci-lint
              delve
              air
              gqlgen
            ];

            shellHook = ''
              export GOPATH="$PWD/.go"
              export GOBIN="$GOPATH/bin"
              export PATH="$GOBIN:$PATH"

              echo "Echo + gqlgen dev shell"
              echo "Go: $(go version)"
              echo "gqlgen: $(gqlgen version 2>/dev/null || echo available)"
            '';
          };
        });

      formatter = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        pkgs.nixpkgs-fmt);
    };
}
