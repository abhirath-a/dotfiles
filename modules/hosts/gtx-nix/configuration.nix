{ self, inputs, ... }: {
  flake.nixosModules.gtxNixConfiguration =
    {
      pkgs,
      config,
      ...
    }:
    {
      imports = [
        self.nixosModules.gtxNixHardware
        inputs.helium-flake.nixosModules.default
      ];

      hardware.uinput.enable = true;
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
      };

      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
      };

      virtualisation.podman.enable = true;
      services.blueman.enable = true;
      programs.nix-ld.enable = true;
      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.graphics.enable = true;
      hardware.nvidia = {
        open = false;
        modesetting.enable = true;
        powerManagement.enable = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
      };
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        wireplumber = {
          enable = true;
          extraConfig.bluetooth-policy."bluetooth.autoswitch-to-headset-profile" = true;
        };
      };

      services.flatpak.enable = true;

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      networking = {
        hostName = "gtx-nix";
        interfaces.enp0s31f6 = {
          wakeOnLan.enable = true;
        };
        firewall = {
          enable = true;
          trustedInterfaces = [ "wg0" ];
          allowedUDPPorts = [
            9
          ];
        };
        networkmanager.enable = true;
      };

      time.timeZone = "America/New_York";
      i18n.defaultLocale = "en_US.UTF-8";

      services.syncthing = {
        enable = true;
        user = "abhi";
        openDefaultPorts = true;
      };

      nixpkgs = {
        config.allowUnfree = true;
      };

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
        "ca-derivations"
      ];

      environment.systemPackages = with pkgs; [
        handy
        pwvucontrol
        vesktop
        prismlauncher
        thunar
        qimgv
        fd
        ripgrep
        mpv
        wtype
        waypipe
        gimp
        input-remapper
        eclipses.eclipse-java
        speedcrunch
      ];
      services.input-remapper.enable = true;
      programs.helium = {
        enable = true;

        flags = [
          "--disable-gpu"
          "--ozone-platform-hint=auto"
        ];

        policies = {
          "BrowserSignin" = 0;
          "PasswordManagerEnabled" = false;
          "SyncDisabled" = true;
          "SpellcheckEnabled" = true;
          "SpellcheckLanguage" = [ "en-US" ];
        };
      };

      fonts = {
        packages = with pkgs; [
          nerd-fonts.iosevka-term
          inter
          source-serif-pro
        ];

        fontconfig = {
          enable = true;
          defaultFonts = {
            serif = [ "Source Serif Pro" ];
            sansSerif = [ "Inter" ];
            monospace = [ "IosevkaTerm Nerd Font" ];
          };
        };
      };

      system.stateVersion = "25.05";
    };
}
