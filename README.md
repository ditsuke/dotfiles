# ditsuke's dotfiles

I manage my dotfiles with [dotter](https://github.com/SuperCuber/dotter/).

My primary package management tool is Nix, more specifically Nix flakes, which I've used as a way
to deterministically declare and pin some of my main used tools with the `flake.nix` and `flake.lock` in
this repo's root. Unfortunately, there's a downside in that it's not the "best" solution that Nix has to
offer but nontheless one I stick to in my stubbornness to use Nix's profiles and flakes.

## Tools I Use

- Package manager: `nix`, Flatpak.
- Editor/PDE: Neovim.

## Installing

1. Fork + clone this repository, or just clone without forking!
   `git clone https://github.com/ditsuke/dotfiles`
2. Run a bootstrap script -- `setup-windows.ps1` for Windows, `setup-fedora.ps1` for Fedora.
   `TODO`: more generic Linux install scripts to follow.
3. Select a dotter configuration files form the `.dotter` directory -- `default-<os>-local.toml`, then
   `cp .dotter/<file.toml> .dotter/local.toml`
4. Apply dotfiles with `dotter deploy`. The bootstrap scripts install _dotter_, but if you skip that dotter
   can be installed independently with Cargo or from GitHub releases.

## Updating

`TODO`
