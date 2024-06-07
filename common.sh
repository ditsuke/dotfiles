#################-- Stuff we're going to install --#################
####################################################################

brew_stuff=(

)

cargo_binstall_stuff=(
	"cargo-make"
	"cargo-update"
)

pipx_stuff=(
	"grip" # preview github-flavored markdown
	"howdoi"
	"poetry"
)

####################################################################
####################################################################

# Nix + nix stuff
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
nix profile install .#d2xyz # Install our flake
# TODO: we need a way to trigger updates

# Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Rust
rustup default stable

## One tool to get all (most) of those binaries without compiling
cargo install cargo-binstall

## Cargo stuff
for stuff in "${cargo_binstall_stuff[@]}"; do
	cargo binstall "${stuff}"
done

# Pipx stuff
for stuff in "${pipx_stuff[@]}"; do
	pipx install "${stuff}"
done

# Brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

## Taps
brew tap isacikgoz/taps

## Brew stuff
for stuff in "${brew_stuff[@]}"; do
	brew install "${stuff}"
done

# Shell
## ohmyzsh for a _delightful_ ZSH experience. In all seriousness consider alternatives like prezto
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"