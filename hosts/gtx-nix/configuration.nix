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
    inputs.home-manager.nixosModules.home-manager
    inputs.nur.modules.nixos.default
    inputs.nur.legacyPackages."x86_64-linux".repos.iopq.modules.xraya
  ];
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
    wireplumber.enable = true;
  };
  services.pipewire.wireplumber.extraConfig.bluetooth-policy."bluetooth.autoswitch-to-headset-profile" =
    true;
  programs.niri.enable = true;
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    users.abhi.imports = [
      ./home.nix
    ];
  };
  services.tailscale.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "gtx-nix";

  networking.networkmanager.enable = true;
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  programs.bash.enable = true;
  users.users.abhi = {
    isNormalUser = true;
    description = "Abhirath Agasanakoppa";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    shell = pkgs.bash;
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
  environment.systemPackages = [
    pkgs.vim
  ];

  services.displayManager.ly.enable = true;
  services.displayManager.ly.settings.pam = true;

  services.openssh.enable = true;

  networking.firewall.enable = true;
  system.stateVersion = "25.05";
}
