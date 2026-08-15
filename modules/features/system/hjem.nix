{ inputs, config, ... }:
{
  flake.nixosModules.hjem = {
    imports = [ inputs.hjem.nixosModules.default ];
    hjem.users.abhi = {
      enable = true;
      directory = "/home/abhi";
      user = "abhi";
    };
  };
}
