{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nixpkgs-unstable }:
    let
      configuration = { pkgs, ... }:

        let
          pkgs-unstable = import nixpkgs-unstable {
            system = "aarch64-darwin";
          };
        in
        let
          args = { inherit pkgs pkgs-unstable; };
          packages =
            [ ]
            ++ (import ./packages/base.nix args)
            ++ (import ./packages/terminal.nix args)
            ++ (import ./packages/apps.nix args)
            ++ (import ./packages/langs.nix args)
            ++ (import ./packages/ide.nix args)
            ++ (import ./packages/utils.nix args);
        in
        let
          zshInit = import ./zshInit.nix; in
        {

          homebrew = {
            enable = true;
            casks = [ "docker" ];
            brews = [
              "xcode-build-server" # CLI package
            ];

          };
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages =
            packages;

          environment.variables = {
            EDITOR = "nvim";
            VISUAL = "nvim";
            GIT_EDITOR = "nvim";
            JAVA_HOME = "${pkgs.jdk}";
          };

          # Installed at /Library/Fonts/Nix\ Fonts/
          fonts.packages = [
            pkgs.nerd-fonts.fira-code
          ];

          system.defaults = import ./system.nix;
          # Necessary for using flakes on this system.
          nix.settings = {
            experimental-features = "nix-command flakes";
            substituters = [
              "https://cache.nixos.org/"
            ];
            trusted-public-keys = [
              "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            ];
            builders-use-substitutes = true;
          };

          programs.zsh = {
            enable = true;
            enableCompletion = true;
            enableBashCompletion = true;
            enableAutosuggestions = true;
            enableSyntaxHighlighting = true;
            shellInit = zshInit.shellInit;
            interactiveShellInit = zshInit.interactiveShellInit { inherit pkgs; };
            loginShellInit = zshInit.loginShellInit;
            promptInit = zshInit.loginShellInit;
            enableFzfCompletion = true;
            enableFzfHistory = true;
          };

          system.primaryUser = "julesguesnon";
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
