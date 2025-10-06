{
  description = "My personal flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
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
                dive # analyze docker images
                docker-slim # docker image analysis, optimize
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
                aider-chat # ai "pair programming"?

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
                shfmt # shell script formatter
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
              ]
              ++ lib.optionals (pkgs.stdenv.isDarwin && pkgs.stdenv.isAarch64) [
                # Docker runtime backend by a transparent linux VM
                # At the moment I haven't set up a service, start explicitly with
                # `colima start` for a daemon, or `colima start --foreground`
                colima
                docker
              ];
            # linux optionals
            # powertop
          };

          # TODO: I need a config-driven flow to enable gui and other optionals etc
          d2gui = pkgs.buildEnv {
            name = "gui stuff";
            paths =
              with pkgs;
              [
                nsxiv # Simple, suckless image viewer
                wireshark # network protocol analyzer
                qbittorrent # torrent client

                # NOTE: Both alacritty and kitty need `nixGL` to run on Linux, but run just fine OOTB on OSX.
                # As such, desktop files created by Nix on Linux systems won't work without modification for
                # these two.
                # Ref: https://github.com/NixOS/nixpkgs/issues/80936
                alacritty
                kitty

                obsidian
                telegram-desktop
                zoom-us
                #thunderbird-latest # email client

              ]
              ++ lib.optionals (pkgs.stdenv.isLinux) [
                ripcord # lightweight native discord client
                vesktop
                slack
                hoppscotch # api client
                uget
                sublime-merge
                (pgadmin4.override { server-mode = false; })
                mpv # media player

                # makes sense in a graphical environment
                xsel
              ]
              ++ lib.optionals (pkgs.stdenv.isDarwin) [
                iina # a modern media player for macOS, based on mpv

                # NOTE: Sublime software does not have arm builds. In an attempt to get
                # merge working on my aarch64 mac, I try to get the x86 build (to run with rosetta).
                # Sadly this doesn't work even with NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM,
                # failing with "expected a set but found null" on evaluation of the `sublime_merge`
                # attribute. This might be resolved with a nixpkgs update at some point, or maybe I'm
                # doing something wrong.
                # I use the build from homebrew for now.
                #
                #nixpkgs.legacyPackages.x86_64-darwin.sublime-merge

                # NOTE: Whatsapp derivation is broken as of 
                #whatsapp-for-mac
              ];
          };

        };
      }
    );
}
