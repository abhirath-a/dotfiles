{ config, ... }:
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        dpi-aware = false;
        icons-enabled = false;
      };
      border.radius = 0;
      colors = {
        background = "${config.lib.stylix.colors.base00}ff";
        text = "${config.lib.stylix.colors.base05}ff";
        placeholder = "${config.lib.stylix.colors.base03}ff";
        prompt = "${config.lib.stylix.colors.base05}ff";
        input = "${config.lib.stylix.colors.base05}ff";
        match = "${config.lib.stylix.colors.base0A}ff";
        selection = "${config.lib.stylix.colors.base03}ff";
        selection-text = "${config.lib.stylix.colors.base05}ff";
        selection-match = "${config.lib.stylix.colors.base0A}ff";
        counter = "${config.lib.stylix.colors.base06}ff";
        border = "${config.lib.stylix.colors.base0D}ff";
      };
    };
  };
  stylix.targets.fuzzel.enable = false;

}
