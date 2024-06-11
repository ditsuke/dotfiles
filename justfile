update-flake:
  nix flake lock --update-input nixpkgs

update-neovim-nightly:
  nix flake lock --update-input neovim-nightly-overlay

build-flake:
  nix build .#d2common

install-flake:
  nix profile remove d2common && nix profile install .#d2common

update: build install-flake
  topgrade
