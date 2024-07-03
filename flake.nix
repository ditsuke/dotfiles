{
  description = "My personal flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs = { self, nixpkgs, ... } @ inputs: {
    # TODO: Generalize to all platforms
    packages.x86_64-linux =
      let
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [ inputs.neovim-nightly-overlay.overlays.default ];
        };
      in
      {
        d2common = pkgs.buildEnv {
          name = "common stuff";
          paths = with pkgs; [
            zsh
            neovim
            dotter # dotfile manager
            nix-tree # Interactively browse dependency graphs of Nix derivations
            jless # pager for json/yaml data
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
            croc
            gitui # Intuitive TUI for git.
            lazygit # Another TUI for git, even more powerful than `gitui`
            kubectl # Kubernetes CLI
            k9s # A TUI to interact with K8S clusters
            minikube # Local Kubernetes cluster
            lima
            cntr # `docker exec` on steroids
            lazydocker # TUI for docker
            bat # cat clone with syntax highlighting
            lnav # log file viewer, indexer!
            bit
            htop # interactive top -- process monitor
            bottom # system monitor
            broot # CLI filesystem explorer and launcher
            joshuto # file manager tui
            llama # CLI file manager, quick launcher. Very simple, very nice
            du-dust # An intuitive `du` alternative
            fd # find alternative
            eza # alternative to ls -- better colors, more attributes and git-aware
            fselect # file-finder with SQL-like queries
            fzf
            glow
            rclone # rsync for the cloud
            ripgrep
            unzip # zip and unzip
            sysbench # benchmarking tool
            docker-compose
            cloudflared # cloudflare tunnel
            ffmpeg # video and audio processing
            topgrade # update all the things with a single command
            strace # system call tracer

            starship # cross-shell prompt
            sd
            wireshark
            zoxide # `z` in rust -- navigate the filesystem fast
            tldr # tldr -- simplified manpages
            kondo # save space by cleaning up dev files (node_modules et al)
            neofetch # quick system info
            zsh
            zsh-completions
            direnv # load environment variables from .envrc and .env files, recursively from CWD
            ghq # Manage remote git repositories
            viu # View images from the terminal. Works with kitty (or iTerm on mac).
            vhs # Write terminal GIFs as code for integration testing and demoing your CLI tools. Ref: github.com/charmbracelet/vhs

            ## devops
            flyctl
            awscli
            ## build tools
            cmake
            just
            ninja
            meson
            ## compilers and interpreters
            rtx # Runtime Executor (asdf-plugin compatible) [github.com:jdx/rtx]
            nodejs_18
            bun
            protobuf
            buf # Tooling for protobufs -- dep management, linting and generation all in one binary.
            go
            rustup # rustup -- rust toolchain installer
            pipx # pipx -- install python packages in isolated environments
            cargo-update # cargo subcommand to check/apply updates to installed executables
            ## dev-deps
            golangci-lint

            # nix
            cachix
          ];
          # linux optionals
          # powertop
        };

        # TODO: I need a config-driven flow to enable gui and other optionals etc
        d2gui = pkgs.buildEnv {
          name = "gui stuff";
          paths = with pkgs; [
            nsxiv # Simple, suckless image viewer

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
  };
}
