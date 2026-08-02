{
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/stylix.nix
    ../../modules/nixos/dnsmasq.nix
    ../../modules/nixos/kanata.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.nur.modules.nixos.default
    inputs.nur.legacyPackages."x86_64-linux".repos.iopq.modules.xraya
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

  programs.niri.enable = true;
  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
    ];

    configPackages = [ pkgs.niri ];
  };
  services.flatpak.enable = true;

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    users.abhi.imports = [
      ./home.nix
      inputs.zen-browser.homeModules.beta
    ];
  };

  services.tailscale.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "gtx-nix";

  networking.networkmanager.enable = true;
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.abhi = {
    isNormalUser = true;
    description = "Abhirath Agasanakoppa";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "uinput"
    ];
    shell = pkgs.bashInteractive;
  };

  services.syncthing = {
    enable = true;
    user = "abhi";
    openDefaultPorts = true;
  };

  nixpkgs = {
    overlays = [
      inputs.abhivim.overlays.default
    ];
    config.allowUnfree = true;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    "ca-derivations"
  ];

  environment.systemPackages = with pkgs; [
    phinger-cursors
    age
    sops
    inputs.handy.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  services.displayManager.ly = {
    enable = true;
    settings.pam = true;
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
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


  networking.firewall.enable = true;
  system.stateVersion = "25.05";
}
