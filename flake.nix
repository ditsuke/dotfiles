{
  description = "My personal flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nix-index = {
      url = "github:nix-community/nix-index";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ inputs.neovim-nightly-overlay.overlays.default ];
        };
      in
      {
        packages = {
          d2common = pkgs.buildEnv {
            name = "common stuff";
            paths =
              with pkgs;
              [
                zsh
                neovim
                dotter # dotfile manager
                jless # pager for json/yaml data
                jc # json-convert -- convert outputs of popular CLI tools to JSON/YAML
                taskwarrior3
                taskwarrior-tui
                taskchampion-sync-server
                zellij # terminal multiplexer

                git # just so we have the latest version
                git-credential-manager # cross-platform git credential storage
                pass # standard unix password manager
                atuin # Alternative, synced shell history backed by an sqlite DB
                p7zip
                difftastic # Structural, syntax-aware difftool
                gh # GitHub CLI
                fx # Interactive JSON browser
                micro # Simple(r) CLI text editor
                tmate # Instant terminal sharing :-:
                croc # Transfer files between machines securely
                gitui # Intuitive TUI for git.
                lazygit # Another TUI for git, even more powerful than `gitui`
                kubectl # Kubernetes CLI
                k9s # A TUI to interact with K8S clusters
                minikube # Local Kubernetes cluster
                lima # create and manage lightweight VMs
                lazydocker # TUI for docker
                bat # cat clone with syntax highlighting
                lnav # log file viewer, indexer!

                bit # TODO: remove?

                htop # interactive top -- process monitor
                bottom # system monitor
                broot # CLI filesystem explorer and launcher
                joshuto # file manager tui
                llama # CLI file manager, quick launcher. Very simple, very nice
                du-dust # An intuitive `du` alternative
                fd # find alternative
                eza # alternative to ls -- better colors, more attributes and git-aware
                fselect # file-finder with SQL-like queries
                fzf # fuzzy finder
                glow # preview markdown files in the terminal
                rclone # rsync for the cloud
                ripgrep # faster, modern grep
                unzip # zip and unzip
                sysbench # benchmarking tool
                docker-compose
                cloudflared # cloudflare tunnel
                ffmpeg # video and audio processing
                topgrade # update all the things with a single command

                starship # cross-shell prompt
                sd # sed alternative
                zoxide # `z` in rust -- navigate the filesystem fast
                tldr # tldr -- simplified manpages
                kondo # save space by cleaning up dev files (node_modules et al)
                neofetch # quick system info
                zsh-completions
                direnv # load environment variables from .envrc and .env files, recursively from CWD
                ghq # Manage remote git repositories
                viu # View images from the terminal. Works with kitty (or iTerm on mac).
                vhs # Write terminal GIFs as code for integration testing and demoing your CLI tools. Ref: github.com/charmbracelet/vhs
                mods # AI on the command line

                ## devops
                flyctl
                awscli
                ## build tools
                gnumake
                cmake
                just
                ninja
                meson
                ## compilers and interpreters
                gcc
                mise # dev tools, env vars, task runner (asdf-plugin compatible) [github.com:jdx/rtx]
                protobuf
                buf # Tooling for protobufs -- dep management, linting and generation all in one binary.
                go
                rustup # rustup -- rust toolchain installer
                pipx # pipx -- install python packages in isolated environments
                cargo-update # cargo subcommand to check/apply updates to installed executables
                ## dev-deps
                golangci-lint

                # nix
                cachix # binary cache manager @ cachix.org
                nix-tree # Interactively browse dependency graphs of Nix derivations
                # Find nix packages containing some specific file(s)
                # This works by indexing built derivations in binary caches.
                # Usage:
                # - Build index with nix-index
                # - Search for packages with nix-locate
                inputs.nix-index.packages.${system}.default
              ]
              ++ lib.optionals (pkgs.stdenv.isLinux) [
                strace # system call tracer
                cntr # `docker exec` on steroids
              ];
            # linux optionals
            # powertop
          };

          # TODO: I need a config-driven flow to enable gui and other optionals etc
          d2gui = pkgs.buildEnv {
            name = "gui stuff";
            paths = with pkgs; [
              nsxiv # Simple, suckless image viewer
              wireshark # network protocol analyzer

              # FIXME: both kitty and alacritty are broken on nixpkgs#1a9df4f74273f90d04e621e8516777efcec2802a
              # I can .. try again when I upgrade next
              # Ref: https://github.com/NixOS/nixpkgs/issues/80936
              # alacritty
              # kitty

              uget
              obsidian
              sublime-merge
              ripcord # lightweight native discord client
              (pgadmin4.override { server-mode = false; })
              hoppscotch # api client
              telegram-desktop
              vesktop
              slack
              zoom-us

              # makes sense in a graphical environment
              xsel
            ];
          };

        };
      }
    );
}
