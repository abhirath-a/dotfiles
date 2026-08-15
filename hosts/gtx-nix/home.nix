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
    XCURSOR_THEME = "phinger-cursors-dark";
    XCURSOR_SIZE = "24";
  };

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
      qt6Packages.qtwayland
      qt5.qtwayland
      wtype
    ]
    ++ scripts.scripts;

  services.mako.enable = true;

  programs.home-manager.enable = true;
  stylix.targets = {
    fzf.colors.override = {
      bg = "-1";
    };
    yazi.enable = false;
  };
}
