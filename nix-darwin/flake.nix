{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
    let
      configuration = { pkgs, ... }:


        let
          args = { inherit pkgs; };
          packages =
            [ pkgs.aerospace ]
            ++ (import ./packages/base.nix args)
            ++ (import ./packages/apps.nix args)
            ++ (import ./packages/langs.nix args)
            ++ (import ./packages/ide.nix args)
            ++ (import ./packages/utils.nix args);
        in
        {

          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages =
            packages;

          # Installed at /Library/Fonts/Nix\ Fonts/
          fonts.packages = [
            pkgs.nerd-fonts.fira-code
          ];

          system.defaults = import ./system.nix;
          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Enable alternative shell support in nix-darwin.
          # programs.fish.enable = true;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 5;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#MacBook-Pro-2
      darwinConfigurations."default" = nix-darwin.lib.darwinSystem {
        modules = [ configuration ];
      };
    };
}
