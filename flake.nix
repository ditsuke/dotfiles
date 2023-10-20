{
  description = "My personal flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.default =
      let
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      in
      pkgs.buildEnv {
        name = "my-env";
        paths = with pkgs; [
          direnv
          jless
          taskwarrior
          taskwarrior-tui
        ];
      };

  };
}
