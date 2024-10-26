export NIXPKGS_ALLOW_UNFREE := "1"
CACHIX_CACHE := "d2kdot"

update-flake:
  nix flake lock --update-input nixpkgs

update-neovim-nightly:
  nix flake lock --update-input neovim-nightly-overlay

build-flake:
  nix build .#d2common --impure

push-cachix:
  @echo "Pushing to cachix..."
  @( [ -f .push-cachix ] && cachix push {{CACHIX_CACHE}} $(readlink -f ./result) ) || \
    echo "NOTE: Not pushing to cachix, enable with \`touch .push-cachix\`"

install-flake: build-flake && push-cachix
  nix profile remove d2common && nix profile install .#d2common --impure --priority 100

build-install-gui: && push-cachix  # TODO: config-driven integration with `install-flake`
  nix build .#d2gui --impure
  nix profile remove d2gui && nix profile install .#d2gui --impure
  ./scripts/link-nix-apps.sh

update: build-flake install-flake
  topgrade

cleanup: # Clean up old nix artifacts
  nix-store --gc
