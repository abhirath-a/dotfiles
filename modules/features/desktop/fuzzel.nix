{ self, inputs, ... }: {
  flake.nixosModules.fuzzel = { pkgs, lib, ... }: {
    environment.systemPackages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.fuzzel ];
  };
  perSystem = { pkgs, ... }: {
    packages.fuzzel = inputs.wrapper-modules.wrappers.fuzzel.wrap {
      inherit pkgs;
      settings = {
        main = {
          dpi-aware = false;
          icons-enabled = false;
        };
        border.radius = 0;
        colors = {
          background = "#${self.theme.base00}ff";
          text = "#${self.theme.base05}ff";
          placeholder = "#${self.theme.base03}ff";
          prompt = "#${self.theme.base05}ff";
          input = "#${self.theme.base05}ff";
          match = "#${self.theme.base0A}ff";
          selection = "#${self.theme.base03}ff";
          selection-text = "#${self.theme.base05}ff";
          selection-match = "#${self.theme.base0A}ff";
          counter = "#${self.theme.base06}ff";
          border = "#${self.theme.base0D}ff";
        };
      };
    };
  };
}
