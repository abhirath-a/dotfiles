{ pkgs, ... }:
{
  home.username = "abhi";
  home.homeDirectory = "/home/abhi";
  imports = [
    ../../modules/homeManager/cmd
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
  };
  home.stateVersion = "25.05";
  home.packages = with pkgs; [
    gcc
    nvim-pkg
    fd
    ripgrep
    unzip
    mosh
    wakeonlan
  ];

  programs.home-manager.enable = true;
}
