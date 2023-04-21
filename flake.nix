{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # flake-parts.url = "github:hercules-ci/flake-parts"
  };
  outputs = { self, nixpkgs, nixpkgs-unstable }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      pkgs-unstable = nixpkgs-unstable.legacyPackages.x86_64-linux;
      system = "x86_64-linux";
      # do not work on docker tests for now
      # tests = import ./tests/tests.nix pkgs;
    in
    rec {

      # packages."${system}" = { } // tests;

      devShell.x86_64-linux =
        pkgs.mkShell {
          nativeBuildInputs = with pkgs;
            [
              git
              # micromamba
              pre-commit
              # texlive.combined.scheme-full
            ] ++ (with pkgs-unstable; [
              helix
              rnix-lsp
              # wkhtmltopdf-bin
              # wkhtmltopdf
              ripgrep
              gitui
              just
              duf
            ]);
        };
    };
}
