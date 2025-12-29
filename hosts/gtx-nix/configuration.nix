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
    "${inputs.nix-mineral}/nix-mineral.nix"
    inputs.sops-nix.nixosModules.sops
  ];
  programs.nix-ld.enable = true;
  services.udisks2.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;
  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    powerManagement.enable = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  programs.niri.enable = true;
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    users.abhi.imports = [
      ./home.nix
      inputs.spicetify-nix.homeManagerModules.default
    ];
  };
  services.tailscale.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "gtx-nix";

  hardware.opentabletdriver.enable = true;
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
  environment.systemPackages = with pkgs; [ vim ];

  services.displayManager.ly.enable = true;
  services.displayManager.ly.settings.pam = true;

  services.openssh.enable = true;

  networking.firewall.enable = true;
  system.stateVersion = "25.05";
}
