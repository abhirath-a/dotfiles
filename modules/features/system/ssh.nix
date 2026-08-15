{
  flake.nixosModules.ssh = {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    programs.mosh = {
      enable = true;
      openFirewall = true;
    };
  };
}
