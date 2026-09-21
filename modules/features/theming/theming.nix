{ self, ... }:

{
  flake.nixosModules.theming =
    { pkgs, ... }:

    {
      environment.systemPackages = with pkgs; [
        libsForQt5.qt5ct
        qt6Packages.qt6ct
        adwaita-icon-theme
        # base16-schemes
      ];

      # ----------------
      # Qt
      # ----------------

      qt = {
        enable = true;
        platformTheme = "qt5ct";
      };

      environment.sessionVariables = {
        QT_QPA_PLATFORM = "xcb";
      };

      # ----------------
      # User configuration
      # ----------------

      hjem.users.abhi = {
        files = {
          # ==============================
          # Qt 5
          # ==============================

          ".config/qt5ct/qt5ct.conf".text = ''
            [Appearance]
            style=Fusion
            icon_theme=Adwaita
            color_scheme_path=/home/abhi/.config/qt5ct/colors/base16.conf
            custom_palette=true

            [Fonts]
            fixed="Iosevka Term,11,-1,5,50,0,0,0,0,0"
            general="Inter,11,-1,5,50,0,0,0,0,0"

            [Interface]
            double_click_interval=400
            gui_effects=@Invalid()
            menus_have_icons=true
            show_shortcuts_in_context_menus=true
            toolbutton_style=4
            underline_shortcut=1
            wheel_scroll_lines=3
          '';

          ".config/qt5ct/colors/base16.conf".text = ''
            [ColorScheme]

            active_colors=#${self.theme.base05}, #${self.theme.base01}, #${self.theme.base04}, #${self.theme.base02}, #${self.theme.base00}, #${self.theme.base00}, #${self.theme.base05}, #${self.theme.base06}, #${self.theme.base05}, #${self.theme.base00}, #${self.theme.base00}, #${self.theme.base00}, #${self.theme.base0D}, #${self.theme.base07}, #${self.theme.base0D}, #${self.theme.base0E}, #${self.theme.base01}, #${self.theme.base05}, #${self.theme.base02}, #${self.theme.base05}, #${self.theme.base04}, #${self.theme.base0D}

            inactive_colors=#${self.theme.base04}, #${self.theme.base01}, #${self.theme.base03}, #${self.theme.base02}, #${self.theme.base00}, #${self.theme.base00}, #${self.theme.base04}, #${self.theme.base05}, #${self.theme.base04}, #${self.theme.base00}, #${self.theme.base00}, #${self.theme.base00}, #${self.theme.base03}, #${self.theme.base04}, #${self.theme.base0D}, #${self.theme.base0E}, #${self.theme.base01}, #${self.theme.base04}, #${self.theme.base02}, #${self.theme.base04}, #${self.theme.base03}, #${self.theme.base0D}

            disabled_colors=#${self.theme.base03}, #${self.theme.base01}, #${self.theme.base03}, #${self.theme.base02}, #${self.theme.base00}, #${self.theme.base00}, #${self.theme.base03}, #${self.theme.base04}, #${self.theme.base03}, #${self.theme.base00}, #${self.theme.base00}, #${self.theme.base00}, #${self.theme.base02}, #${self.theme.base03}, #${self.theme.base03}, #${self.theme.base03}, #${self.theme.base01}, #${self.theme.base03}, #${self.theme.base02}, #${self.theme.base03}, #${self.theme.base03}, #${self.theme.base03}
          '';

          # ==============================
          # Qt 6
          # ==============================

          ".config/qt6ct/qt6ct.conf".text = ''
            [Appearance]
            style=Fusion
            icon_theme=Adwaita
            color_scheme_path=/home/abhi/.config/qt6ct/colors/base16.conf
            custom_palette=true

            [Fonts]
            fixed="Iosevka Term,11,-1,5,50,0,0,0,0,0"
            general="Inter,11,-1,5,50,0,0,0,0,0"

            [Interface]
            double_click_interval=400
            gui_effects=@Invalid()
            menus_have_icons=true
            show_shortcuts_in_context_menus=true
            toolbutton_style=4
            underline_shortcut=1
            wheel_scroll_lines=3
          '';

          ".config/qt6ct/colors/base16.conf".text = ''
            [ColorScheme]

            active_colors=#${self.theme.base05}, #${self.theme.base01}, #${self.theme.base04}, #${self.theme.base02}, #${self.theme.base00}, #${self.theme.base00}, #${self.theme.base05}, #${self.theme.base06}, #${self.theme.base05}, #${self.theme.base00}, #${self.theme.base00}, #${self.theme.base00}, #${self.theme.base0D}, #${self.theme.base07}, #${self.theme.base0D}, #${self.theme.base0E}, #${self.theme.base01}, #${self.theme.base05}, #${self.theme.base02}, #${self.theme.base05}, #${self.theme.base04}, #${self.theme.base0D}

            inactive_colors=#${self.theme.base04}, #${self.theme.base01}, #${self.theme.base03}, #${self.theme.base02}, #${self.theme.base00}, #${self.theme.base00}, #${self.theme.base04}, #${self.theme.base05}, #${self.theme.base04}, #${self.theme.base00}, #${self.theme.base00}, #${self.theme.base00}, #${self.theme.base03}, #${self.theme.base04}, #${self.theme.base0D}, #${self.theme.base0E}, #${self.theme.base01}, #${self.theme.base04}, #${self.theme.base02}, #${self.theme.base04}, #${self.theme.base03}, #${self.theme.base0D}

            disabled_colors=#${self.theme.base03}, #${self.theme.base01}, #${self.theme.base03}, #${self.theme.base02}, #${self.theme.base00}, #${self.theme.base00}, #${self.theme.base03}, #${self.theme.base04}, #${self.theme.base03}, #${self.theme.base00}, #${self.theme.base00}, #${self.theme.base00}, #${self.theme.base02}, #${self.theme.base03}, #${self.theme.base03}, #${self.theme.base03}, #${self.theme.base03}, #${self.theme.base01}, #${self.theme.base03}, #${self.theme.base02}, #${self.theme.base03}, #${self.theme.base03}, #${self.theme.base03}
          '';
                    # ==============================
          # GTK 3
          # ==============================

          ".config/gtk-3.0/settings.ini".text = ''
            [Settings]
            gtk-theme-name=Adwaita
            gtk-icon-theme-name=Adwaita
            gtk-font-name=Inter 11
            gtk-cursor-theme-name=Adwaita
            gtk-application-prefer-dark-theme=true
          '';

          ".config/gtk-3.0/gtk.css".text = ''
            /* ============================================================
             * Base16 GTK 3
             *
             * base00  background       #090e13
             * base01  surface          #23252b
             * base02  elevated/border  #282a30
             * base03  muted            #393b44
             * base04  secondary text   #a4a7a4
             * base05  foreground       #d0d0d0
             * base06  bright text      #e6e6e6
             * base07  brightest        #f7f7ec
             * base0D  accent           #8ba4b0
             * ============================================================ */

            /* ---- Global ---- */

            * {
              color: #${self.theme.base05};
              -GtkWidget-link-color: #${self.theme.base0D};
              -GtkWidget-visited-link-color: #${self.theme.base0F};
            }

            window,
            .background {
              background-color: #${self.theme.base00};
              color: #${self.theme.base05};
            }

            /* ---- Headerbars / titlebars ---- */

            headerbar,
            .titlebar {
              background-color: #${self.theme.base01};
              color: #${self.theme.base06};
              border-color: #${self.theme.base02};
              box-shadow: none;
            }

            headerbar:backdrop,
            .titlebar:backdrop {
              background-color: #${self.theme.base01};
              color: #${self.theme.base04};
            }

            headerbar entry,
            headerbar button {
              background-color: transparent;
              border-color: transparent;
            }

            /* ---- Buttons ---- */

            button {
              background-color: #${self.theme.base01};
              background-image: none;
              color: #${self.theme.base05};
              border-color: #${self.theme.base02};
              box-shadow: none;
              text-shadow: none;
            }

            button:hover {
              background-color: #${self.theme.base02};
              color: #${self.theme.base06};
            }

            button:active,
            button:checked {
              background-color: #${self.theme.base03};
              color: #${self.theme.base07};
            }

            button:focus {
              border-color: #${self.theme.base0D};
              box-shadow: inset 0 0 0 1px #${self.theme.base0D};
            }

            button:disabled {
              background-color: #${self.theme.base01};
              color: #${self.theme.base03};
              border-color: #${self.theme.base02};
            }

            /* ---- Entries / text fields ---- */

            entry,
            spinbutton,
            textview,
            treeview {
              background-color: #${self.theme.base00};
              color: #${self.theme.base05};
              border-color: #${self.theme.base02};
              caret-color: #${self.theme.base0D};
              box-shadow: none;
            }

            entry:focus,
            spinbutton:focus {
              border-color: #${self.theme.base0D};
              box-shadow: inset 0 0 0 1px #${self.theme.base0D};
            }

            entry:disabled,
            spinbutton:disabled {
              background-color: #${self.theme.base01};
              color: #${self.theme.base03};
            }

            /* ---- Selection ---- */

            selection {
              background-color: #${self.theme.base0D};
              color: #${self.theme.base07};
            }

            /* ---- Lists / tree views ---- */

            treeview.view {
              background-color: #${self.theme.base00};
              color: #${self.theme.base05};
            }

            treeview.view:hover {
              background-color: #${self.theme.base01};
            }

            treeview.view:selected {
              background-color: #${self.theme.base0D};
              color: #${self.theme.base07};
            }

            row:selected,
            list row:selected {
              background-color: #${self.theme.base0D};
              color: #${self.theme.base07};
            }

            row:hover,
            list row:hover {
              background-color: #${self.theme.base01};
            }

            /* ---- Sidebar ---- */

            placessidebar,
            placesview,
            .sidebar {
              background-color: #${self.theme.base01};
              color: #${self.theme.base05};
              border-color: #${self.theme.base02};
            }

            placessidebar row,
            .sidebar row {
              color: #${self.theme.base05};
            }

            placessidebar row:hover,
            .sidebar row:hover {
              background-color: #${self.theme.base02};
            }

            placessidebar row:selected,
            .sidebar row:selected {
              background-color: #${self.theme.base03};
              color: #${self.theme.base07};
            }

            /* ---- Menus / popovers ---- */

            menu,
            menuitem,
            popover {
              background-color: #${self.theme.base01};
              color: #${self.theme.base05};
              border-color: #${self.theme.base02};
            }

            menuitem:hover {
              background-color: #${self.theme.base02};
              color: #${self.theme.base06};
            }

            /* ---- Tooltips ---- */

            tooltip {
              background-color: #${self.theme.base01};
              color: #${self.theme.base06};
              border: 1px solid #${self.theme.base02};
            }

            /* ---- Checkboxes / radio buttons ---- */

            checkbutton,
            radiobutton {
              color: #${self.theme.base05};
            }

            checkbutton:hover,
            radiobutton:hover {
              color: #${self.theme.base06};
            }

            checkbutton:checked,
            radiobutton:checked {
              color: #${self.theme.base0D};
            }

            /* ---- Switches ---- */

            switch {
              background-color: #${self.theme.base03};
              border-color: #${self.theme.base02};
            }

            switch:checked {
              background-color: #${self.theme.base0D};
            }

            switch slider {
              background-color: #${self.theme.base05};
            }

            /* ---- Scales / progress ---- */

            scale trough,
            progressbar trough {
              background-color: #${self.theme.base02};
            }

            scale highlight,
            progressbar progress {
              background-color: #${self.theme.base0D};
            }

            scale slider {
              background-color: #${self.theme.base05};
              border-color: #${self.theme.base02};
            }

            scale slider:hover {
              background-color: #${self.theme.base06};
            }

            /* ---- Scrollbars ---- */

            scrollbar {
              background-color: transparent;
            }

            scrollbar slider {
              background-color: #${self.theme.base03};
              border-color: transparent;
            }

            scrollbar slider:hover {
              background-color: #${self.theme.base04};
            }

            scrollbar slider:active {
              background-color: #${self.theme.base0D};
            }

            /* ---- Separators ---- */

            separator {
              background-color: #${self.theme.base02};
              min-width: 1px;
              min-height: 1px;
            }

            /* ---- Links ---- */

            *:link {
              color: #${self.theme.base0D};
            }

            *:visited {
              color: #${self.theme.base0F};
            }

            /* ---- Disabled ---- */

            *:disabled {
              color: #${self.theme.base03};
            }
          '';

          # ==============================
          # GTK 4
          # ==============================

          ".config/gtk-4.0/settings.ini".text = ''
            [Settings]
            gtk-theme-name=Adwaita
            gtk-icon-theme-name=Adwaita
            gtk-font-name=Inter 11
            gtk-cursor-theme-name=Adwaita
            gtk-application-prefer-dark-theme=true
          '';

          ".config/gtk-4.0/gtk.css".text = ''
            /* ============================================================
             * Base16 GTK 4
             * ============================================================ */

            /* ---- Base window ---- */

            window,
            .background {
              background-color: #${self.theme.base00};
              color: #${self.theme.base05};
            }

            /* ---- Headerbar ---- */

            headerbar {
              background-color: #${self.theme.base01};
              color: #${self.theme.base06};
              box-shadow: none;
              border-color: #${self.theme.base02};
            }

            headerbar:backdrop {
              background-color: #${self.theme.base01};
              color: #${self.theme.base04};
            }

            /* ---- Buttons ---- */

            button {
              background-color: #${self.theme.base01};
              color: #${self.theme.base05};
              background-image: none;
              box-shadow: none;
              border-color: #${self.theme.base02};
            }

            button:hover {
              background-color: #${self.theme.base02};
              color: #${self.theme.base06};
            }

            button:active,
            button:checked {
              background-color: #${self.theme.base03};
              color: #${self.theme.base07};
            }

            button:focus {
              border-color: #${self.theme.base0D};
            }

            button:disabled {
              color: #${self.theme.base03};
            }

            /* ---- Text fields ---- */

            entry,
            spinbutton,
            textview {
              background-color: #${self.theme.base00};
              color: #${self.theme.base05};
              border-color: #${self.theme.base02};
              caret-color: #${self.theme.base0D};
            }

            entry:focus,
            spinbutton:focus {
              border-color: #${self.theme.base0D};
            }

            /* ---- Selection ---- */

            selection {
              background-color: #${self.theme.base0D};
              color: #${self.theme.base07};
            }

            /* ---- Lists ---- */

            list,
            listview {
              background-color: #${self.theme.base00};
              color: #${self.theme.base05};
            }

            row {
              color: #${self.theme.base05};
            }

            row:hover {
              background-color: #${self.theme.base01};
            }

            row:selected {
              background-color: #${self.theme.base0D};
              color: #${self.theme.base07};
            }

            /* ---- Sidebar ---- */

            sidebar,
            .sidebar {
              background-color: #${self.theme.base01};
              color: #${self.theme.base05};
              border-color: #${self.theme.base02};
            }

            sidebar row:hover,
            .sidebar row:hover {
              background-color: #${self.theme.base02};
            }

            sidebar row:selected,
            .sidebar row:selected {
              background-color: #${self.theme.base03};
              color: #${self.theme.base07};
            }

            /* ---- Popovers / menus ---- */

            popover {
              background-color: #${self.theme.base01};
              color: #${self.theme.base05};
              border-color: #${self.theme.base02};
            }

            popover contents {
              background-color: #${self.theme.base01};
            }

            /* ---- Check/radio ---- */

            checkbutton,
            radiobutton {
              color: #${self.theme.base05};
            }

            checkbutton:checked,
            radiobutton:checked {
              color: #${self.theme.base0D};
            }

            /* ---- Switches ---- */

            switch {
              background-color: #${self.theme.base03};
              border-color: #${self.theme.base02};
            }

            switch:checked {
              background-color: #${self.theme.base0D};
            }

            switch slider {
              background-color: #${self.theme.base05};
            }

            /* ---- Scales / progress ---- */

            scale trough,
            progressbar trough {
              background-color: #${self.theme.base02};
            }

            scale highlight,
            progressbar progress {
              background-color: #${self.theme.base0D};
            }

            scale slider {
              background-color: #${self.theme.base05};
            }

            scale slider:hover {
              background-color: #${self.theme.base06};
            }

            /* ---- Scrollbars ---- */

            scrollbar slider {
              background-color: #${self.theme.base03};
            }

            scrollbar slider:hover {
              background-color: #${self.theme.base04};
            }

            scrollbar slider:active {
              background-color: #${self.theme.base0D};
            }

            /* ---- Separators ---- */

            separator {
              background-color: #${self.theme.base02};
            }

            /* ---- Tooltips ---- */

            tooltip {
              background-color: #${self.theme.base01};
              color: #${self.theme.base06};
              border-color: #${self.theme.base02};
            }

            /* ---- Disabled ---- */

            :disabled {
              color: #${self.theme.base03};
            }
          '';
        };
      };
    };
}
