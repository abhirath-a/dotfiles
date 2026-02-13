{ pkgs, config, ... }:
{
  programs.niri = {
    settings = with config.lib.niri.actions; {
      input.mod-key = "Super";
      animations.enable = false;
      spawn-at-startup = [
        {
          argv = [
            ''${pkgs.swaybg}/bin/swaybg''
            "-i"
            ''${../../wallpapers/beach-kanso.jpg}''
          ];
        }
      ];
      prefer-no-csd = true;
      layout = {
        gaps = 4;
        border.enable = false;
        focus-ring = {
          enable = true;
          width=1.5;
        };
        default-column-width.proportion = 0.5;
      };
      gestures.hot-corners.enable = false;
      overview.workspace-shadow.enable = false;
      binds = {
        "Mod+D".action.spawn = ["fuzzel"];
        "Mod+T".action = spawn "foot";

        "Mod+E".action = spawn "bemoji";

        "Mod+Q".action = close-window;
        "Mod+Shift+Q".action = quit;

        "Mod+H".action = focus-column-left;
        "Mod+J".action = focus-window-down;
        "Mod+K".action = focus-window-up;
        "Mod+L".action = focus-column-right;
        "Mod+Shift+h".action = move-column-left;
        "Mod+Shift+l".action = move-column-right;
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
      };
      window-rules = [
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
