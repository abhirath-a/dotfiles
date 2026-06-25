{ pkgs, ... }:
{
  stylix.targets.sioyek.enable = false;
  programs.sioyek = {

    package = pkgs.symlinkJoin {
      name = "sioyek-xcb";
      paths = [ pkgs.sioyek ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/sioyek \
          --set QT_QPA_PLATFORM xcb
      '';
    };

    enable = true;
    bindings = {
      screen_down = "<C-d>";
      screen_up = "<C-u>";
      prev_state = "<C-o>";
      toggle_titlebar = "<C-w>";
      next_state = "<C-i>";
      zoom_in = "J";
      zoom_out = "K";

      toggle_dark_mode = "i";
      toggle_custom_color = "c";
      reload_config = "r";
      # helper_window

      fit_to_page_width = "s";
    };
    config = {
      check_for_updates_on_startup = "0";
      use_legacy_keybinds = "0";
      search_url_s = "https://scholar.google.com/scholar?q=";
      search_url_l = "http://gen.lib.rus.ec/scimag/?q=";
      search_url_g = "https://www.google.com/search?q=";
      middle_click_search_engine = "s";
      shift_middle_click_search_engine = "l";
      zoom_inc_factor = "1.2";
      vertical_move_amount = "1.0";
      horizontal_move_amount = "1.0";
      move_screen_ratio = "0.5";
      flat_toc = "0";
      should_use_multiple_monitors = "0";
      should_load_tutorial_when_no_other_file = "1";
      should_launch_new_instance = "0";
      should_launch_new_window = "0";
      visual_mark_next_page_fraction = "0.75";
      visual_mark_next_page_threshold = " 0.25";
      should_draw_unrendered_pages = "0";
      rerender_overview = "1";
      default_dark_mode = "0";
      sort_bookmarks_by_location = "1";
      startup_commands = [ "toggle_custom_color" ];
      wheel_zoom_on_cursor = "0";
      fit_to_page_width_ratio = "0.75";
      collapsed_toc = "0";
      ruler_mode = "1";
      ruler_padding = "1.0";
      ruler_x_padding = "5.0";
      create_table_of_contents_if_not_exists = "1";
      max_created_toc_size = "5000";
      should_warn_about_user_key_override = "1";
      single_click_selects_words = "0";
      multiline_menus = "1";
      prerender_next_page_presentation = "1";
    };
  };
}
