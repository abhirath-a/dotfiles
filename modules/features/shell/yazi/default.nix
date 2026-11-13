{ self, inputs, ... }:
{
  flake.nixosModules.yazi =
    { pkgs, ... }:
    {
      programs.yazi = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.yazi;
      };
      environment.systemPackages = [
        pkgs.duckdb
        pkgs.imagemagick
      ];
    };

  flake.darwinModules.yazi =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.duckdb
        pkgs.imagemagick
        self.packages.${pkgs.stdenv.hostPlatform.system}.yazi
      ];
    };
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        yazi = inputs.wrapper-modules.wrappers.yazi.wrap {
          inherit pkgs;
          package = pkgs.yazi;
          flavors = {
            kanso-zen = ./kanso-zen.yazi;
          };
          plugins = with pkgs.yaziPlugins; {
            git = git;
            sudo = sudo;
            mount = mount;
            sshfs = sshfs;
            duckdb = duckdb;
            convert = convert;
          };
          settings.theme.flavor = {
            light = "kanso-zen";
            dark = "kanso-zen";
          };
        };
      };
    };
}
