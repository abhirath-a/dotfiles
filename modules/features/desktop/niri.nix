{ self, inputs, ... }:

{
  flake.nixosModules.niri =
    { pkgs, lib, ... }:
    {
      programs.niri = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri;
      };
      environment.systemPackages = [
        pkgs.phinger-cursors
        pkgs.xwayland-satellite
        pkgs.wl-clipboard
        pkgs.playerctl
      ];
      services.displayManager.ly = {
        enable = true;
        settings.pam = true;
      };
    };

  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {
      packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;

        settings = {
          input.mod-key = "Super";

          animations.off = { };

          spawn-sh-at-startup = [
            "${lib.getExe pkgs.swaybg} -i ${self.wallpaper} -m fill"
          ];

          prefer-no-csd = true;

          layout = {
            gaps = 4;

            border.off = { };

            focus-ring = {
              width = 0.5;
              active-color = "#${self.theme.base06}";
            };

            default-column-width.proportion = 0.5;
          };
          cursor = {
            xcursor-theme = "phinger-cursors-dark";
            xcursor-size = 24;
          };

          outputs = {
            "HDMI-A-3" = {
              mode = "1920x1080@60.000";

              position = _: {
                props = {
                  x = 0;
                  y = 0;
                };
              };
            };

            "HDMI-A-1" = {
              mode = "1080x1920@60.000";

              position = _: {
                props = {
                  x = 1920;
                  y = 0;
                };
              };

              transform = "90";
            };
          };

          gestures.hot-corners.off = { };

          overview.workspace-shadow.off = { };

          binds = {
            "Mod+D".spawn = lib.getExe self'.packages.fuzzel;
            "Mod+T".spawn = lib.getExe self'.packages.foot;
            "Mod+E".spawn = lib.getExe pkgs.bemoji;
            "Mod+Space".spawn-sh = "${lib.getExe pkgs.handy} --toggle-transcription";

            "Mod+Q".close-window = { };
            "Mod+Shift+Q".quit = { };

            "Mod+H".focus-column-or-monitor-left = { };
            "Mod+J".focus-window-or-workspace-down = { };
            "Mod+K".focus-window-or-workspace-up = { };
            "Mod+L".focus-column-or-monitor-right = { };

            "Mod+Shift+H".move-column-left-or-to-monitor-left = { };
            "Mod+Shift+L".move-column-right-or-to-monitor-right = { };
            "Mod+Shift+J".move-window-down = { };
            "Mod+Shift+K".move-window-up = { };

            "Mod+Minus".set-column-width = "-10%";
            "Mod+Equal".set-column-width = "+10%";
            "Mod+Shift+Minus".set-window-height = "-10%";
            "Mod+Shift+Equal".set-window-height = "+10%";

            "Mod+Shift+S".screenshot = { };

            "Mod+BracketRight".consume-or-expel-window-right = { };
            "Mod+BracketLeft".consume-or-expel-window-left = { };
            "Mod+Period".consume-window-into-column = { };
            "Mod+Shift+Period".expel-window-from-column = { };

            "Mod+P".switch-preset-column-width = { };
            "Mod+Shift+P".switch-preset-window-height = { };

            "Mod+Ctrl+D".reset-window-height = { };

            "Mod+F".maximize-column = { };
            "Mod+Shift+F".fullscreen-window = { };
            "Mod+Ctrl+F".expand-column-to-available-width = { };

            "Mod+G".center-column = { };

            "Mod+1".focus-workspace = 1;
            "Mod+2".focus-workspace = 2;
            "Mod+3".focus-workspace = 3;
            "Mod+4".focus-workspace = 4;
            "Mod+5".focus-workspace = 5;
            "Mod+6".focus-workspace = 6;
            "Mod+7".focus-workspace = 7;
            "Mod+8".focus-workspace = 8;
            "Mod+9".focus-workspace = 9;

            "Mod+Shift+1".move-window-to-workspace = 1;
            "Mod+Shift+2".move-window-to-workspace = 2;
            "Mod+Shift+3".move-window-to-workspace = 3;
            "Mod+Shift+4".move-window-to-workspace = 4;
            "Mod+Shift+5".move-window-to-workspace = 5;
            "Mod+Shift+6".move-window-to-workspace = 6;
            "Mod+Shift+7".move-window-to-workspace = 7;
            "Mod+Shift+8".move-window-to-workspace = 8;
            "Mod+Shift+9".move-window-to-workspace = 9;

            "Mod+O".toggle-overview = { };
            "Mod+Slash".show-hotkey-overlay = { };

            "XF86AudioRaiseVolume".spawn-sh =
              "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0";

            "XF86AudioLowerVolume".spawn-sh =
              "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";

            "XF86AudioMute".spawn-sh =
              "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

            "XF86AudioMicMute".spawn-sh =
              "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
            "XF86AudioPlay".spawn-sh = "${pkgs.playerctl}/bin/playerctl play-pause";
            "XF86AudioPause".spawn-sh = "${pkgs.playerctl}/bin/playerctl play-pause";
            "XF86AudioNext".spawn-sh = "${pkgs.playerctl}/bin/playerctl next";
            "XF86AudioPrev".spawn-sh = "${pkgs.playerctl}/bin/playerctl previous";
            "XF86AudioStop".spawn-sh = "${pkgs.playerctl}/bin/playerctl stop";

            "Mod+U".focus-workspace-down = { };
            "Mod+I".focus-workspace-up = { };

            "Mod+Ctrl+U".move-column-to-workspace-down = { };
            "Mod+Ctrl+I".move-column-to-workspace-up = { };

            "Mod+V".toggle-window-floating = { };
            "Mod+Shift+V".switch-focus-between-floating-and-tiling = { };
          };

          window-rules = [
            {
              matches = [
                { app-id = "sioyek"; }
              ];

              open-on-output = "HDMI-A-1";
              default-column-width.proportion = 1.0;
            }
          ];
        };
      };
    };
}
