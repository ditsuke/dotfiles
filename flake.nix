{
  description = "My personal flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # TODO: add nvim-nightly
  };

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.default =
      let
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      in
      pkgs.buildEnv {
        name = "my-env";
        paths = with pkgs; [
          nix-tree # Interactively browse dependency graphs of Nix derivations
          jless
          taskwarrior
          taskwarrior-tui


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
          lazydocker # TUI for docker
          bat # cat clone with syntax highlighting
          lnav
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

          starship # cross-shell prompt
          sd
          wireshark
          zoxide # `z` in rust -- navigate the filesystem fast
          tldr # tldr -- simplified manpages
          kondo # save space by cleaning up dev files (node_modules et al)
          neofetch # quick system info
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
          ninja
          meson
          ## compilers and interpreters
          rtx # Runtime Executor (asdf-plugin compatible) [github.com:jdx/rtx]
          nodejs
          bun
          protobuf
          buf # Tooling for protobufs -- dep management, linting and generation all in one binary.
          go
          ## dev-deps
          golangci-lint
        ];
      };

  };
}
