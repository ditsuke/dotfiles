export NIXPKGS_ALLOW_UNFREE := "1"

update-flake:
  nix flake lock --update-input nixpkgs

update-neovim-nightly:
  nix flake lock --update-input neovim-nightly-overlay

build-flake:
  nix build .#d2common --impure

install-flake:
  nix profile remove d2common && nix profile install .#d2common --impure

build-install-gui: # TODO: config-driven integration with `install-flake`
  nix build .#d2gui --impure
  nix profile remove d2gui && nix profile install .#d2gui --impure

update: build-flake install-flake
  topgrade

cleanup: # Clean up old nix artifacts
  nix-store --gc
