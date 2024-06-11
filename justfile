update-flake:
  nix flake lock --update-input nixpkgs

update-neovim-nightly:
  nix flake lock --update-input neovim-nightly-overlay

build:
  nix build .#d2common

update: build
  nix profile remove d2common && nix profile install .#d2common
  topgrade
