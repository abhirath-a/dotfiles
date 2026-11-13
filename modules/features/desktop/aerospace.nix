{
  flake.darwinModules.aerospace = {
    services.aerospace = {
      enable = true;

      settings = {
        default-root-container-layout = "tiles";
        default-root-container-orientation = "auto";

        # Keep workspace layouts predictable
        enable-normalization-flatten-containers = true;

        gaps = {
          inner.horizontal = 2;
          inner.vertical = 2;
          outer.left = 2;
          outer.right = 2;
          outer.top = 2;
          outer.bottom = 2;
        };

        mode.main.binding = {
          # Focus windows with Vim keys
          alt-h = "focus left";
          alt-j = "focus down";
          alt-k = "focus up";
          alt-l = "focus right";

          # Move windows
          alt-shift-h = "move left";
          alt-shift-j = "move down";
          alt-shift-k = "move up";
          alt-shift-l = "move right";

          # Resize
          alt-minus = "resize smart -50";
          alt-equal = "resize smart +50";

          # Workspace switching
          alt-1 = "workspace 1";
          alt-2 = "workspace 2";
          alt-3 = "workspace 3";
          alt-4 = "workspace 4";
          alt-5 = "workspace 5";

          # Move windows between workspaces
          alt-shift-1 = "move-node-to-workspace 1";
          alt-shift-2 = "move-node-to-workspace 2";
          alt-shift-3 = "move-node-to-workspace 3";
          alt-shift-4 = "move-node-to-workspace 4";
          alt-shift-5 = "move-node-to-workspace 5";

          # Layout
          alt-slash = "layout tiles horizontal vertical";
          alt-comma = "layout accordion horizontal vertical";

          # Toggle floating
          alt-shift-space = "layout floating tiling";

          # Fullscreen
          alt-f = "fullscreen";

          # Reload configuration
          alt-shift-r = "reload-config";

          alt-q = "close --quit-if-last-window";
        };
      };
    };
  };
}
