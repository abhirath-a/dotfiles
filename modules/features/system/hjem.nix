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
  flake.darwinModules.hjem = {
    imports = [ inputs.hjem.darwinModules.default ];
    hjem.users.abhi = {
      enable = true;
      directory = "/Users/abhi";
      user = "abhi";
    };
  };
}
