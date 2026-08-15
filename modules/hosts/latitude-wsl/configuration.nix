{ inputs, ... }:
{
  flake.nixosModules.latitudeWslConfiguration =
    { pkgs, ... }:
    {
      networking.hostName = "latitude-wsl";
      imports = [ inputs.nixos-wsl.nixosModules.default ];
      nixpkgs = {
        config.allowUnfree = true;
        hostPlatform = "x86_64-linux";
      };

      environment.systemPackages = with pkgs; [
        fd
        ripgrep
        wakeonlan
      ];

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
        "ca-derivations"
      ];

      services.openssh.enable = true;

      networking.firewall.enable = true;
      system.stateVersion = "25.05";

      wsl.enable = true;
      wsl.defaultUser = "abhi";
    };
}
