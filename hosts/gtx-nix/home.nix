{ pkgs, ... }:
{
  home.username = "abhi";
  home.homeDirectory = "/home/abhi";
  imports = [
    ../../modules/homeManager/cmd
    ../../modules/homeManager/programs
    ../../modules/homeManager/wm
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
  };
  home.stateVersion = "25.05";
  home.packages = with pkgs; [
    gcc
    gimp
    swaybg
    prismlauncher
    wl-clipboard
    bemoji
    xournalpp
    adwaita-icon-theme
    xfce.thunar
    nvim-pkg
    libreoffice-qt6-fresh
    qimgv
    fd
    ripgrep
    mpv
    unzip
    darktable
    xwayland-satellite
    sleek-todo
    sops
    age
    pwvucontrol
  ];
  programs.fuzzel.enable = true;
  services.mako.enable = true;
  programs.waybar.enable = true;

  programs.home-manager.enable = true;
}
