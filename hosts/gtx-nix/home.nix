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
    stdenv
    gimp
    swaybg
    prismlauncher
    wl-clipboard
    bemoji
    adwaita-icon-theme
    xfce.thunar
    nvim-pkg
    qimgv
    fd
    ripgrep
    mpv
    unzip
    darktable
    xwayland-satellite
    pwvucontrol
    xdg-desktop-portal-gnome
  ];
  programs.fuzzel.enable = true;
  services.mako.enable = true;

  programs.home-manager.enable = true;
}
