{ pkgs, config, ... }:
{
  programs.niri = {
    settings = with config.lib.niri.actions; {
      input.mod-key = "Super";
      animations.enable = false;
      spawn-at-startup = [
        {
          argv = [
            "${pkgs.swaybg}/bin/swaybg"
            "-i"
            "${../../wallpapers/SAAM-1925.12.2_1.jpg}"
            "-m"
            "fill"
          ];
        }
      ];
      prefer-no-csd = true;
      layout = {
        gaps = 4;
        border.enable = false;
        focus-ring = {
          enable = true;
          width = 0.5;
          active.color = config.lib.stylix.colors.base06;
        };
        default-column-width.proportion = 0.5;
      };
      cursor = {
        theme = "phinger-cursors-dark";
        size = 24;
      };
      outputs = {
        "HDMI-A-3" = {
          mode = {
            width = 1920;
            height = 1080;
            refresh = 60.0;
          };
          position = {
            x = 0;
            y = 0;
          };
        };

        "HDMI-A-1" = {
          mode = {
            height = 1920;
            width = 1080;
            refresh = 60.0;
          };
          position = {
            x = 1920;
            y = 0;
          };
          transform.rotation = 90;
        };
      };
      gestures.hot-corners.enable = false;
      overview.workspace-shadow.enable = false;
      binds = {
        "Mod+D".action.spawn = [ ''${pkgs.fuzzel}/bin/fuzzel'' ];
        "Mod+T".action = spawn ''${pkgs.foot}/bin/foot'';

        "Mod+E".action = spawn "${pkgs.bemoji}/bin/bemoji";
        "Mod+Space".action = spawn-sh "handy --toggle-transcription";

        "Mod+Q".action = close-window;
        "Mod+Shift+Q".action = quit;

        "Mod+H".action = focus-column-or-monitor-left;
        "Mod+J".action = focus-window-or-workspace-down;
        "Mod+K".action = focus-window-or-workspace-up;
        "Mod+L".action = focus-column-or-monitor-right;
        "Mod+Shift+h".action = move-column-left-or-to-monitor-left;
        "Mod+Shift+l".action = move-column-right-or-to-monitor-right;
        "Mod+Shift+j".action = move-window-down;
        "Mod+Shift+k".action = move-window-up;
        "Mod+Minus".action = set-column-width "-10%";
        "Mod+Equal".action = set-column-width "+10%";
        "Mod+Shift+Minus".action = set-window-height "-10%";
        "Mod+Shift+Equal".action = set-window-height "+10%";

        "Mod+Shift+S".action.screenshot = [ ];

        "Mod+BracketRight".action = consume-or-expel-window-right;
        "Mod+BracketLeft".action = consume-or-expel-window-left;
        "Mod+period".action = consume-window-into-column;
        "Mod+Shift+period".action = expel-window-from-column;

        "Mod+P".action = switch-preset-column-width;
        "Mod+Shift+P".action = switch-preset-window-height;

        "Mod+Ctrl+D".action = reset-window-height;

        "Mod+F".action = maximize-column;
        "Mod+Shift+F".action = fullscreen-window;
        "Mod+Ctrl+F".action = expand-column-to-available-width;

        "Mod+G".action = center-column;

        "Mod+1".action = focus-workspace 1;
        "Mod+2".action = focus-workspace 2;
        "Mod+3".action = focus-workspace 3;
        "Mod+4".action = focus-workspace 4;
        "Mod+5".action = focus-workspace 5;
        "Mod+6".action = focus-workspace 6;
        "Mod+7".action = focus-workspace 7;
        "Mod+8".action = focus-workspace 8;
        "Mod+9".action = focus-workspace 9;
        "Mod+Shift+1".action.move-window-to-workspace = 1;
        "Mod+Shift+2".action.move-window-to-workspace = 2;
        "Mod+Shift+3".action.move-window-to-workspace = 3;
        "Mod+Shift+4".action.move-window-to-workspace = 4;
        "Mod+Shift+5".action.move-window-to-workspace = 5;
        "Mod+Shift+6".action.move-window-to-workspace = 6;
        "Mod+Shift+7".action.move-window-to-workspace = 7;
        "Mod+Shift+8".action.move-window-to-workspace = 8;
        "Mod+Shift+9".action.move-window-to-workspace = 9;

        "Mod+O".action = toggle-overview;
        "Mod+slash".action = show-hotkey-overlay;
        "XF86AudioRaiseVolume".action = spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0";
        "XF86AudioLowerVolume".action = spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
        "XF86AudioMute".action = spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioMicMute".action = spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

        "Mod+U".action = focus-workspace-down;
        "Mod+I".action = focus-workspace-up;
        "Mod+Ctrl+U".action = move-column-to-workspace-down;
        "Mod+Ctrl+I".action = move-column-to-workspace-up;
        "Mod+V".action = toggle-window-floating;
        "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;
      };
      window-rules = [
        {
          matches = [ { app-id = "sioyek"; } ];
          open-on-output = "HDMI-A-1";
          default-column-width.proportion = 1.0;
        }
        {
          geometry-corner-radius = {
            bottom-left = 0.0;
            bottom-right = 0.0;
            top-left = 0.0;
            top-right = 0.0;
          };
          clip-to-geometry = true;
          draw-border-with-background = false;
        }
      ];
    };
  };
}
