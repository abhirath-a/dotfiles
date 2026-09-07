{
  flake.nixosModules.wireguard = { config, ... }: {
    networking.wg-quick.interfaces = {
      wg0 = {
        address = [
          "10.50.0.3/24"
        ];
        # use dnscrypt, or proxy dns as described above
        dns = [ "10.50.0.1" ];
        privateKeyFile = config.sops.secrets."gtx_nix_wireguard_private_key".path;
        peers = [
          {
            publicKey = "JiYJQe/iNiinyz43TkFdtP3TOO28fBmR5YqkC4Cg9hI=";
            allowedIPs = [
              "10.50.0.0/24"
              "192.168.1.0/24"
            ];
            endpoint = "vpn.abhirath.net:51820";
          }
        ];
      };
    };
  };
}
