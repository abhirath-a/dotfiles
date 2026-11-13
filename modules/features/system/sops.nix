{ inputs, ... }: {
  flake.nixosModules.sops = { pkgs, ... }: {
    imports = [ inputs.sops-nix.nixosModules.sops ];

    environment.systemPackages = with pkgs; [
      sops
      age
    ];

    sops = {
      defaultSopsFile = ../../../secrets/secrets.yaml;
      secrets = {
        "gtx_nix_wireguard_private_key" = { };
      };
    };
  };

  flake.darwinModules.sops = { pkgs, ... }: {
    imports = [ inputs.sops-nix.darwinModules.sops ];

    environment.systemPackages = with pkgs; [
      sops
      age
      age-plugin-se
    ];

    sops = {
      defaultSopsFile = ../../../secrets/secrets.yaml;
    };
  };
}
