{
  description = "My personal flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, nixpkgs, ... } @ inputs: {
    # TODO: Generalize to all platforms
    packages.x86_64-linux.d2xyz =
      let
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [ inputs.neovim-nightly-overlay.overlays.default ];
        };
      in
      pkgs.buildEnv {
        name = "ditsuke's nix env";
        paths = with pkgs; [
          neovim
          dotter # dotfile manager
          nix-tree # Interactively browse dependency graphs of Nix derivations
          jless
          taskwarrior3
          taskwarrior-tui
          taskchampion-sync-server
          zellij # terminal multiplexer

          git # just so we have the latest version
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
          cntr # `docker exec` on steroids
          lazydocker # TUI for docker
          bat # cat clone with syntax highlighting
          lnav # log file viewer, indexer!
          bit
          htop # interactive top -- process monitor
          bottom # system monitor
          broot # CLI filesystem explorer and launcher
          llama # CLI file manager, quick launcher. Very simple, very nice
          du-dust # An intuitive `du` alternative
          fd
          eza # modern alternative to ls -- better colors, more attributes and git-aware
          fselect # file-finder with SQL-like queries
          fzf
          glow
          rclone # rsync for the cloud
          ripgrep
          unzip # zip and unzip
          sysbench # benchmarking tool
          docker-compose
          cloudflared # cloudflare tunnel
          topgrade # update all the things with a single command

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
          nodejs
          bun
          protobuf
          buf # Tooling for protobufs -- dep management, linting and generation all in one binary.
          go
          rustup # rustup -- rust toolchain installer
          pipx # pipx -- install python packages in isolated environments
          ## dev-deps
          golangci-lint
        ];
      };
  };
}
