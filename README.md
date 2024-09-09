# ditsuke's dotfiles

I manage my dotfiles with [dotter](https://github.com/SuperCuber/dotter/).

My primary package management tool is Nix, more specifically Nix flakes, which I've used as a way
to deterministically declare and pin some of my main used tools with the `flake.nix` and `flake.lock` in
this repo's root.

## What I use

- OS: Fedora Workstation.
- Package manager: `nix`, Flatpak. Os-specific package managers are used when necessary.
- Editor: Neovim.

... And several tools that can be found in ./flake.nix

## Bootstrapping

1. Fork + clone this repository, or just clone without forking!
   `git clone https://github.com/ditsuke/dotfiles`
2. Run a bootstrap script -- `setup-fedora.ps1` for Fedora, `./common.sh` for any distro.
   I'll add in finer control for bootstrapping at a later point.

## Dotfiles

1. Select a dotter configuration from the the `.dotter` directory -- `default-<os>-local.toml`, then
   `cp .dotter/<file.toml> .dotter/local.toml`
2. Apply dotfiles with `dotter`. The bootstrap scripts install _dotter_ with Nix, but if you skip that dotter
   can be installed independently with Cargo or from GitHub releases.

## Updating

`just update-flake && just update` will update all packages. Anything not managed by
Nix is upgraded with `topgrade`.

If you add a new package to `flake.nix`, use `just install-flake` to build and install it.
