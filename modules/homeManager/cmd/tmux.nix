{ ... }:
{
  programs.tmux = {
    enable = true;
    prefix = "C-s";
    baseIndex = 1;
    keyMode = "vi";
    extraConfig = ''
      set -ogq @thm_bg "#090E13"
      set -ogq @thm_fg "#C5C9C7"

# Colors
      set -ogq @thm_rosewater "#c4746e"
      set -ogq @thm_flamingo "#b98d7b"
      set -ogq @thm_pink "#a292a3"
      set -ogq @thm_mauve "#938AA9"
      set -ogq @thm_red "#C34043"
      set -ogq @thm_maroon "#E46876"
      set -ogq @thm_peach "#b6927b"
      set -ogq @thm_yellow "#DCA561"
      set -ogq @thm_green "#98BB6C"
      set -ogq @thm_teal "#8ea4a2"
      set -ogq @thm_sky "#658594"
      set -ogq @thm_sapphire "#7FB4CA"
      set -ogq @thm_blue "#8ba4b0"
      set -ogq @thm_lavender "#8992a7"

# Surfaces and overlays
      set -ogq @thm_subtext_1 "#717C7C"
      set -ogq @thm_subtext_0 "#A4A7A4"
      set -ogq @thm_overlay_2 "#909398"
      set -ogq @thm_overlay_1 "#75797f"
      set -ogq @thm_overlay_0 "#4b4e57"
      set -ogq @thm_surface_2 "#393B44"
      set -ogq @thm_surface_1 "#22262D"
      set -ogq @thm_surface_0 "#1C1E25"
      set -ogq @thm_mantle "#090E13"
      set -ogq @thm_crust "#000000"
      set -g status-position top
      set -g status-justify absolute-centre
      set -g status-style "bg=default"
      set -g window-status-current-style "fg=blue bold"
      set -g status-right ""
      set -g status-left "#S"
      set -g window-status-style "fg=white bg=default"
      set -g renumber-windows on
      set -a terminal-features "tmux-256color:RGB"
      set -ga terminal-overrides ",*:Tc"
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R
    '';
  };
}
