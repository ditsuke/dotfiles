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

## Personal and work Git identities

Set profile variables under `[variables]` in `.dotter/local.toml`, then run
`dotter`. The default is personal; set `git_default_identity = "work"` to change
it. Existing `git_name`, `git_email`, `gpg_format`, `gpg_binary`, `gpg_key_id`, and
`ssh_key` variables remain fallbacks for the personal profile.

For example, personal GPG signing and work SSH signing:

```toml
[variables]
git_default_identity = "personal" # or "work"

personal_git_name = "Your Name"
personal_git_email = "you@personal.example"
personal_ssh_key = "~/.ssh/id_personal"
personal_gpg_format = "openpgp"
personal_gpg_key_id = "YOUR_GPG_KEY_ID"
personal_gpg_binary = "gpg"

work_git_name = "Your Name"
work_git_email = "you@company.example"
work_ssh_key = "~/.ssh/id_work"
work_gpg_format = "ssh"
work_gpg_key_id = "~/.ssh/id_work_signing.pub"
# Optional executable overrides:
# work_gpg_binary = "gpg"
# work_ssh_signing_binary = "ssh-keygen"
# personal_ssh_signing_binary = "ssh-keygen"
```

Each profile chooses its signing format independently: `openpgp` for GPG or
`ssh`. The legacy value `gpg` is also accepted and rendered as `openpgp`.
`*_gpg_key_id` is the signing key: a GPG key ID, an SSH private key path, or an
SSH public key path whose private key is loaded in `ssh-agent`. `*_ssh_key` is
the separate SSH authentication key used for fetch/push over SSH. Key paths
can start with `~/`; SSH authentication paths may contain spaces, but should
not contain single quotes. SSH signing uses `ssh-keygen`, independently of the
GPG executable. This configuration selects existing keys; it does not generate
or register them with your Git host.

Inside a repository:

```sh
git as-me     # set the personal identity, authentication key, and signing settings
git as-work   # set the work identity, authentication key, and signing settings
```

These commands write to `.git/config`, enable commit signing, and leave remotes
unchanged. They validate the selected profile before changing anything, so an
unconfigured work profile fails without altering the repo. Both profiles set
their signing executables explicitly to prevent stale settings when switching.
Existing repositories with local identity settings keep those overrides until
you run one of the commands. Changing the default affects repositories without
local overrides; rerun a command after editing a profile to refresh its local
settings. SSH key selection applies to SSH remotes; HTTPS uses the existing
credential helper. To inspect the effective configuration:

```sh
git config --show-origin --get-regexp '^(user\.|gpg\.|core\.sshCommand|commit\.gpgsign)'
```

## Updating

`just update-flake && just update` will update all packages. Anything not managed by
Nix is upgraded with `topgrade`.

If you add a new package to `flake.nix`, use `just install-flake` to build and install it.
