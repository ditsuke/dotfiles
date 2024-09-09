#!/bin/bash

./setup-common.sh

nix profile install .#d2gui # Install GUI stuff

dnf_stuff=(
	"kitty" # broken on nix
	"zsh"
	"sqlite3"      # some dnf shell-completions need sqlite
	"sqlite-devel" # Some neovim extensions require both sqlite and sqlite-devel
	"howdy"        # Windows Hello-like facial recognition for Linux
	"cronie"       # crontab
	"docker"
	"docker-compose"
	"tlp"          # Optimise better life
	"wev"          # wayland input viewer -- installed while I was debugging a wayland issue
	"dconf-editor" # Edit the dconf k-v store with a GUI
	"qalc"         # CLI calculator, hooks up to frontends. Used by pop-launcher
	"xprop"        # Manage window and font properties on X servers. Needed by the Unite shell extension.

	## Gnome shell extensions
	"gnome-shell-extension-user-theme"
	"pop-shell" # tiling extension from Pop OS!

	## GUI apps
	"gnome-tweaks"
	"gnome-power-manager"

	"lm_sensors"
)

flathub_stuff=(
	"com.obsproject.studio"
	"org.gnome.Extensions"
	"io.bassi.Amberol"
	"com.mattjakeman.ExtensionManager" # Manage gnome shell extensions
	"io.github.jonmagon.kdiskmark"
)

####################################################################
# DNF

## Repos

### RPM Fusion Free
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm

### RPM Fusion Non-free
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm

### COPR Repo for Howdy
sudo dnf copr enable principis/howdy -y

### Tailscale
sudo dnf config-manager --add-repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo

## Installs
for stuff in "${dnf_stuff[@]}"; do
	sudo dnf install "${stuff}" -y
done

### Services
sudo systemctl enable --now tailscaled

# ohmyzsh for a _delightful_ ZSH experience. In all seriousness consider alternatives like prezto
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Python apps

## Start by installing pipx for isolated python app management (pypa.github.io/pipx)
pip install pipx

# Flathub
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo # add flathub repo

for stuff in "${flathub_stuff[@]}"; do
	flatpak install flathub "${stuff}"
done

# AppImages

## AppImageLauncher
APPIMAGELAUNCHER="appimagelauncher.rpm"
wget
"https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher-2.2.0-travis995.0f91801.$(uname -m).rpm" --output-document /tmp/$APPIMAGELAUNCHER
sudo dnf install /tmp/$APPIMAGELAUNCHER

## Jetbrains Toolbox
curl -fsSL https://raw.githubusercontent.com/nagygergo/jetbrains-toolbox-install/master/jetbrains-toolbox.sh | sudo bash

# Misc

## tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
