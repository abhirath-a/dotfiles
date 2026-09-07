{ self, ... }:
{
  flake.nixosModules.anki = { pkgs, ... }: {
    environment.systemPackages = [
      (pkgs.anki.withAddons (
        with pkgs.ankiAddons;
        [
          (recolor.withConfig {
            config = {
              colors = {
                ACCENT_CARD = [
                  "Card mode"
                  "#${self.theme.base0B}"
                  "#${self.theme.base0B}"
                  "--accent-card"
                ];
                ACCENT_DANGER = [
                  "Danger"
                  "#${self.theme.base08}"
                  "#${self.theme.base08}"
                  "--accent-danger"
                ];
                ACCENT_NOTE = [
                  "Note mode"
                  "#${self.theme.base0C}"
                  "#${self.theme.base0C}"
                  "--accent-note"
                ];
                BORDER = [
                  "Border"
                  "#45475a"
                  "#45475a"
                  "--border"
                ];
                BORDER_FOCUS = [
                  "Border (focused input)"
                  "#${self.theme.base0D}"
                  "#${self.theme.base0D}"
                  "--border-focus"
                ];
                BORDER_STRONG = [
                  "Border (strong)"
                  "#585b70"
                  "#585b70"
                  "--border-strong"
                ];
                BORDER_SUBTLE = [
                  "Border (subtle)"
                  "#313244"
                  "#313244"
                  "--border-subtle"
                ];
                BUTTON_BG = [
                  "Button background"
                  "#313244"
                  "#313244"
                  "--button-bg"
                ];
                BUTTON_DISABLED = [
                  "Button background (disabled)"
                  "#313244"
                  "#313244"
                  "--button-disabled"
                ];
                BUTTON_HOVER = [
                  "Button background (hover)"
                  "#45475a"
                  "#45475a"
                  [
                    "--button-gradient-start"
                    "--button-gradient-end"
                  ]
                ];
                BUTTON_HOVER_BORDER = [
                  "Button border (hover)"
                  "#585b70"
                  "#585b70"
                  "--button-hover-border"
                ];
                BUTTON_PRIMARY_BG = [
                  "Button Primary Bg"
                  "#2f67e1"
                  "#2f67e1"
                  "--button-primary-bg"
                ];
                BUTTON_PRIMARY_DISABLED = [
                  "Button Primary Disabled"
                  "#4484ed"
                  "#4484ed"
                  "--button-primary-disabled"
                ];
                BUTTON_PRIMARY_GRADIENT_END = [
                  "Button Primary Gradient End"
                  "#2544a8"
                  "#2544a8"
                  "--button-primary-gradient-end"
                ];
                BUTTON_PRIMARY_GRADIENT_START = [
                  "Button Primary Gradient Start"
                  "#2f67e1"
                  "#2f67e1"
                  "--button-primary-gradient-start"
                ];
                CANVAS = [
                  "Background"
                  "#${self.theme.base00}"
                  "#${self.theme.base00}"
                  [
                    "--canvas"
                    "--bs-body-bg"
                  ]
                ];
                CANVAS_CODE = [
                  "Code editor background"
                  "#${self.theme.base01}"
                  "#${self.theme.base01}"
                  "--canvas-code"
                ];
                CANVAS_ELEVATED = [
                  "Review"
                  "#${self.theme.base01}"
                  "#${self.theme.base01}"
                  "--canvas-elevated"
                ];
                CANVAS_GLASS = [
                  "Background (transparent text surface)"
                  "#${self.theme.base01}66"
                  "#${self.theme.base01}66"
                  "--canvas-glass"
                ];
                CANVAS_INSET = [
                  "Background (inset)"
                  "#${self.theme.base02}"
                  "#${self.theme.base02}"
                  "--canvas-inset"
                ];
                CANVAS_OVERLAY = [
                  "Background (menu & tooltip)"
                  "#${self.theme.base02}"
                  "#${self.theme.base02}"
                  "--canvas-overlay"
                ];
                FG = [
                  "Text"
                  "#${self.theme.base07}"
                  "#${self.theme.base07}"
                  [
                    "--fg"
                    "--bs-body-color"
                    "--bs-form-control-color"
                  ]
                ];
                FG_DISABLED = [
                  "Text (disabled)"
                  "#${self.theme.base05}"
                  "#${self.theme.base05}"
                  "--fg-disabled"
                ];
                FG_FAINT = [
                  "Text (faint)"
                  "#${self.theme.base04}"
                  "#${self.theme.base04}"
                  "--fg-faint"
                ];
                FG_LINK = [
                  "Text (link)"
                  "#${self.theme.base0D}"
                  "#${self.theme.base0D}"
                  "--fg-link"
                ];
                FG_SUBTLE = [
                  "Text (subtle)"
                  "#${self.theme.base03}"
                  "#${self.theme.base03}"
                  "--fg-subtle"
                ];
                FLAG_1 = [
                  "Flag 1"
                  "#${self.theme.base08}"
                  "#${self.theme.base08}"
                  "--flag-1"
                ];
                FLAG_2 = [
                  "Flag 2"
                  "#${self.theme.base09}"
                  "#${self.theme.base09}"
                  "--flag-2"
                ];
                FLAG_3 = [
                  "Flag 3"
                  "#${self.theme.base0A}"
                  "#${self.theme.base0A}"
                  "--flag-3"
                ];
                FLAG_4 = [
                  "Flag 4"
                  "#${self.theme.base0B}"
                  "#${self.theme.base0B}"
                  "--flag-4"
                ];
                FLAG_5 = [
                  "Flag 5"
                  "#${self.theme.base0D}"
                  "#${self.theme.base0D}"
                  "--flag-5"
                ];
                FLAG_6 = [
                  "Flag 6"
                  "#${self.theme.base0C}"
                  "#${self.theme.base0C}"
                  "--flag-6"
                ];
                FLAG_7 = [
                  "Flag 7"
                  "#c9cbff"
                  "#c9cbff"
                  "--flag-7"
                ];
                HIGHLIGHT_BG = [
                  "Highlight background"
                  "#${self.theme.base0F}"
                  "#${self.theme.base0F}"
                  "--highlight-bg"
                ];
                HIGHLIGHT_FG = [
                  "Highlight text"
                  "#${self.theme.base0D}"
                  "#${self.theme.base0D}"
                  "--highlight-fg"
                ];
                SCROLLBAR_BG = [
                  "Scrollbar background"
                  "#1e1e2e"
                  "#1e1e2e"
                  "--scrollbar-bg"
                ];
                SCROLLBAR_BG_ACTIVE = [
                  "Scrollbar background (active)"
                  "#313244"
                  "#313244"
                  "--scrollbar-bg-active"
                ];
                SCROLLBAR_BG_HOVER = [
                  "Scrollbar background (hover)"
                  "#${self.theme.base00}"
                  "#${self.theme.base00}"
                  "--scrollbar-bg-hover"
                ];
                SELECTED_BG = [
                  "Selected Bg"
                  "#313244"
                  "#313244"
                  "--selected-bg"
                ];
                SELECTED_FG = [
                  "Selected Fg"
                  "#${self.theme.base0A}"
                  "#${self.theme.base0A}"
                  "--selected-fg"
                ];
                SHADOW = [
                  "Shadow"
                  "#1e1e2e"
                  "#1e1e2e"
                  "--shadow"
                ];
                SHADOW_FOCUS = [
                  "Shadow  =focused input)"
                  "#${self.theme.base0D}"
                  "#${self.theme.base0D}"
                  "--shadow-focus"
                ];
                SHADOW_INSET = [
                  "Shadow (inset)"
                  "#11111b"
                  "#11111b"
                  "--shadow-inset"
                ];
                SHADOW_SUBTLE = [
                  "Shadow (subtle)"
                  "#181825"
                  "#181825"
                  "--shadow-subtle"
                ];
                STATE_BURIED = [
                  "Buried"
                  "#7f849c"
                  "#7f849c"
                  "--state-buried"
                ];
                STATE_LEARN = [
                  "Learn"
                  "#${self.theme.base08}"
                  "#${self.theme.base08}"
                  "--state-learn"
                ];
                STATE_MARKED = [
                  "Marked"
                  "#${self.theme.base09}"
                  "#${self.theme.base09}"
                  "--state-marked"
                ];
                STATE_NEW = [
                  "New"
                  "#${self.theme.base0C}"
                  "#${self.theme.base0C}"
                  "--state-new"
                ];
                STATE_REVIEW = [
                  "Review"
                  "#${self.theme.base0D}"
                  "#${self.theme.base0D}"
                  "--state-review"
                ];
                STATE_SUSPENDED = [
                  "Suspended"
                  "#${self.theme.base06}"
                  "#${self.theme.base06}"
                  "--state-suspended"
                ];
              };
              version = {
                major = 3;
                minor = 1;
              };
            };
          })
          # anki-connect
          review-heatmap
          image-occlusion-enhanced
        ]
      ))
    ];
  };
}
