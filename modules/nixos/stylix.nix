{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.stylix.nixosModules.stylix ];
  stylix = {
    enable = true;
    targets = {
      fzf.colors.override = {
        bg = "-1";
      };
      yazi.enable = false;
    };
    base16Scheme = {
      base00 = "#090e13";
      base01 = "#23252b";
      base02 = "#282a30";
      base03 = "#393b44";
      base04 = "#a4a7a4";
      base05 = "#d0d0d0";
      base06 = "#e6e6e6";
      base07 = "#f7f7ec";
      base08 = "#c4746e";
      base09 = "#b6927b";
      base0A = "#c4b28a";
      base0B = "#8a9a7b";
      base0C = "#8ea4a2";
      base0D = "#8ba4b0";
      base0E = "#a292a3";
      base0F = "#938aa9";
    };
    fonts = lib.flip lib.mapAttrs config.fonts.fontconfig.defaultFonts (
      family: _: {
        name = family;
        package = pkgs.emptyDirectory;
      }
    );
  };
}
