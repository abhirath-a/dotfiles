{ pkgs, ... }:
let
  scripts = import ../../modules/homeManager/cmd/scripts.nix { inherit pkgs; };
in
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
    QT_QPA_PLATFORM = "xcb";
      XCURSOR_THEME = "phinger-cursors-dark";
  XCURSOR_SIZE = "24";
  };

  # home.pointerCursor = {
  #   gtk.enable = true;
  #   x11.enable = true;
  #   package = pkgs.phinger-cursors;
  #   name = "phinger-cursors-dark"; 
  #   size = 24; 
  # };

  home.stateVersion = "25.05";
  home.packages =
    with pkgs;
    [
      gcc
      stdenv
      swaybg
      prismlauncher
      wl-clipboard
      bemoji
      adwaita-icon-theme
      thunar
      nvim-pkg
      qimgv
      fd
      ripgrep
      mpv
      unzip
      xwayland-satellite
      pwvucontrol
      xdg-desktop-portal-gnome
    ]
    ++ scripts.scripts;
  programs.fuzzel.enable = true;
  services.mako.enable = true;

  programs.home-manager.enable = true;
}
