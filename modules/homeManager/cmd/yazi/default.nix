{
  stylix.targets.yazi.enable = false;
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    flavors = {
      kanso-zen = ./kanso-zen.yazi;
    };
    theme = {
      flavor = {
        dark = "kanso-zen";
        light = "kanso-zen";
      };
    };
  };
}
