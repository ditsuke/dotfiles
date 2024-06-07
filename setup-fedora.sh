#!/bin/bash

./common.sh

dnf_stuff=(
  "zsh"
  "python3-pip"  # use pip to install pipx :D
  "sqlite3"      # some dnf shell-completions need sqlite
  "sqlite-devel" # Some neovim extensions require both sqlite and sqlite-devel
  "howdy"        # Windows Hello-like facial recognition for Linux
  "ffmpeg"
  "xsel"      # interface with the system clipboard. neovim uses this as the clipboard provider.
  "cronie"    # crontab
  "gammastep" # color temp, brightness control | ! Mark
  "docker"
  "docker-compose"
  "tlp"          # Optimise better life
  "bluez"        # bluetooth from the cli (?)
  "strace"       # trace processes
  "tailscale"    # easy mesh VPN++
  "wev"          # wayland input viewer -- installed while I'm debugging the input lag/misses on AC
  "dconf-editor" # Edit the dconf k-v store with a GUI
  "qalc"         # CLI calculator, hooks up to frontends. Used by pop-launcher
  "xprop"        # Manage window and font properties on X servers. Needed by the Unite shell extension.

  ## TUIs
  "powertop" # Monitor and diagnose issues with battery usage.
  "joshuto"  # Ranger-like file management TUI written in Rust

  ## Language support
  "perl"

  ## Gnome shell extensions
  "gnome-shell-extension-user-theme"
  "pop-shell" # tiling extension from Pop OS!

  ## GUI apps
  "code"        # VSCode, because yes
  "kolourpaint" # KDE's image editor | ! mark for removal
  "gnome-tweaks"
  "gnome-extensions-app"
  "gnome-power-manager"
  "ulauncher"
  "evolution"  # mail client
  "ripcord"    # a lightweight native discord client
  "kdiskmark"  # SSD benchmarking tool, like CrystalDiskMark but on Linux
  "kitty"      # A better terminal emulator
  "nsxiv"      # Simple, suckless image viewer (GUI)
  "uget"       # Download manager
  "obs-studio" # Open Broadcaster -- stream, record screen and more

  ## build deps
  "gcc-c++"
  "cyrus-sasl-devel"
  "libinput-devel"
  "systemd-devel"
  "libgtop2-devel"
  "openssl-devel"
  "gmp-devel"

  "lm_sensors"
  "lld"
)

flathub_stuff=(
  "md.obsidian.Obsidian"
  "com.discordapp.Discord"
  "org.telegram.desktop"
  "org.gnome.Extensions"
  "com.slack.Slack"
  "com.sublimemerge.App"
  "com.getpostman.Postman"
  "io.bassi.Amberol"
  "gg.guilded.Guilded"
  "com.mattjakeman.ExtensionManager" # Manage gnome shell extensions?
  "com.mongodb.Compass"
)

####################################################################
# DNF

## Repos

### Visual Studio Code
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

### RPM Fusion Free
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm

### RPM Fusion Non-free
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm

### COPR Repo for Howdy
sudo dnf copr enable principis/howdy -y

### COPR Repo for Jushuto
sudo dnf copr enable atim/joshuto -y

### COPR Repo for nsxiv
sudo dnf copr enable mamg22/nsxiv

### COPR Repo for neovim-nightly
dnf copr enable agriffis/neovim-nightly

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

## ngrok -- sadly not on fedora repos/flathub
wget "https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz" --output-document /tmp/ngrok.tgz # TODO: modularize arch?
tar xvzf /tmp/ngrok.tgz -C ~/.local/bin

## tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
