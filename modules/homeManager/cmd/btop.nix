{ ... }:
{
  programs.btop = {
    enable = true;
    settings = {
      theme_background = false;
      temp_scale = "celsius";
      vim_keys = true;
    };
  };
}
