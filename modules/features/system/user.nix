{ config, lib, ... }:
{
  flake.nixosModules.user = { pkgs, ... }: {
    users.users.abhi = {
      isNormalUser = true;
      description = "Abhirath Agasanakoppa";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "uinput"
        "video"
      ];
      shell = pkgs.bashInteractive;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIzsAiIp0B2m2W6gNwQgnDla3RNNCVLvnblP/ull3uNw arun@DESKTOP-NIL5T2N"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZ1KTPya0xcIat9G+RkNiXvVMeVoR4Qr+4abhUrKIyI abhi@latitude-wsl"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIEmV+nQ3CHocuzM3L8AS8FEWYLEt6JeoGJ+OKrbtgss #SSH ID - @abhirath"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBzMufGfgPadH4VlS26zDtY+yKaSfuMd/iWI/0C7+tMe hello@abhirath.net"
      ];
    };
  };
}
