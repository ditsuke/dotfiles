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
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm --extra-conf "trusted-users = $(id -n -u)"
source /etc/profile.d/nix.sh             # Load the nix profile
nix run nixpkgs#cachix use nix-community # binary cache that has neovim-nightly
nix profile install .#d2common           # Install our flake

# Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Rust
rustup default stable

## One tool to get all (most) of those binaries without compiling
cargo install cargo-binstall

## Cargo stuff
for stuff in "${cargo_binstall_stuff[@]}"; do
	cargo binstall "${stuff}" --no-confirm
done

# Pipx stuff
for stuff in "${pipx_stuff[@]}"; do
	pipx install "${stuff}"
done

# Brew
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

## Taps
brew tap isacikgoz/taps

## Brew stuff
for stuff in "${brew_stuff[@]}"; do
	brew install "${stuff}"
done

# Shell
## ohmyzsh for a _delightful_ ZSH experience. In all seriousness consider alternatives like prezto
git clone https://github.com/ohmyzsh/ohmyzsh ~/.oh-my-zsh

echo "Done installing base layer. Next steps:"
echo "1. GUI? Install \`.#d2gui\`"
echo "2. Install dotfiles with \`dotter\`"
echo "3. Setup tailscale with \`sudo tailscale up\`"
