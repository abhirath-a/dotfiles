{ self, inputs, ... }:
{
  flake.darwinModules.abhi-macbookConfiguration =
    { pkgs, ... }:
    {
      nixpkgs.hostPlatform = "aarch64-darwin";

      # Machine identity
      networking.hostName = "abhi-macbook";
      networking.computerName = "abhi-macbook";

      # Nix
      nix.enable = true;
      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        auto-optimise-store = true;
      };

      nix.gc = {
        automatic = true;
        interval = {
          Weekday = 0;
          Hour = 3;
          Minute = 0;
        };
        options = "--delete-older-than 14d";
      };
      programs.ssh = {
        extraConfig = ''
          Host *
          	IdentityAgent /Users/abhi/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh
        '';
      };
      # Shell
      programs.zsh = {
        enable = true;
        enableCompletion = true;

        interactiveShellInit = ''
          setopt HIST_IGNORE_DUPS
          setopt SHARE_HISTORY
          export SSH_AUTH_SOCK=/Users/abhi/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh
        '';

        promptInit = ''
          PROMPT='%F{75}%~ %F{189}%# %f'
        '';
      };
      environment.systemPackages = with pkgs; [
        self.packages.${pkgs.stdenv.hostPlatform.system}.nvim
        self.packages.${pkgs.stdenv.hostPlatform.system}.tmux
        inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
        firefox
        handy
        ripgrep
        fd
        fzf
        jq
        wget
        curl
        direnv
        tree
        just
        iosevka-bin
        anki-bin
        codex
        secretive
      ];

      environment.variables = {
        "EDITOR" = "nvim";
        "MANPAGER" = "nvim +Man!";
        "HISTIGNORE" = "exit:cd:ls:bg:fg:history:f:fd:vim";
      };

      nixpkgs.config.allowUnfree = true;

      fonts.packages = [ pkgs.iosevka-bin ];

      # macOS preferences
      system.defaults = {
        dock = {
          autohide = true;
          show-recents = false;
          tilesize = 42;
          mru-spaces = false;
        };

        finder = {
          AppleShowAllExtensions = true;
          AppleShowAllFiles = true;
          FXPreferredViewStyle = "Nlsv";
          ShowPathbar = true;
          ShowStatusBar = true;
        };

        NSGlobalDomain = {
          ApplePressAndHoldEnabled = false;
          KeyRepeat = 2;
          InitialKeyRepeat = 15;
          AppleShowAllExtensions = true;
          "com.apple.swipescrolldirection" = true;
        };

        trackpad = {
          Clicking = true;
          TrackpadThreeFingerDrag = true;
        };
      };

      # Touch ID for sudo
      security.pam.services.sudo_local.touchIdAuth = true;

      # Required nix-darwin settings
      system.stateVersion = 6;
      system.primaryUser = "abhi";
    };
}
