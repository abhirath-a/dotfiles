{ self, ... }:

{
  flake.nixosModules.theming =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        adwaita-icon-theme

        # qt6Packages.qt6ct
        # libsForQt5.qt5ct
      ];

      hjem.users.abhi = {
        files = {
          # GTK 3
          ".config/gtk-3.0/settings.ini".text = ''
            [Settings]
            gtk-theme-name=Base16
            gtk-icon-theme-name=Adwaita
            gtk-application-prefer-dark-theme=1
          '';

          # GTK 4 / libadwaita: don't try to force a custom CSS theme.
          # Just tell applications to prefer dark mode.
          ".config/gtk-4.0/settings.ini".text = ''
            [Settings]
            gtk-application-prefer-dark-theme=1
          '';

          # Base16 GTK 3 theme
          ".local/share/themes/Base16/gtk-3.0/gtk.css".text = ''
            @define-color base00 #${self.theme.base00};
            @define-color base01 #${self.theme.base01};
            @define-color base02 #${self.theme.base02};
            @define-color base03 #${self.theme.base03};
            @define-color base04 #${self.theme.base04};
            @define-color base05 #${self.theme.base05};
            @define-color base06 #${self.theme.base06};
            @define-color base07 #${self.theme.base07};
            @define-color base08 #${self.theme.base08};
            @define-color base09 #${self.theme.base09};
            @define-color base0A #${self.theme.base0A};
            @define-color base0B #${self.theme.base0B};
            @define-color base0C #${self.theme.base0C};
            @define-color base0D #${self.theme.base0D};
            @define-color base0E #${self.theme.base0E};
            @define-color base0F #${self.theme.base0F};

            * {
              color: @base05;
            }

            window,
            dialog {
              background-color: @base00;
              color: @base05;
            }

            button {
              background-color: @base01;
              color: @base05;
              border-color: @base02;
            }

            button:hover {
              background-color: @base02;
            }

            button:active,
            button:checked {
              background-color: @base02;
            }

            entry,
            spinbutton,
            search,
            combobox {
              background-color: @base01;
              color: @base05;
              border-color: @base02;
            }

            entry:focus,
            spinbutton:focus,
            search:focus {
              border-color: @base0D;
            }

            menu,
            popover {
              background-color: @base01;
              color: @base05;
            }

            tooltip {
              background-color: @base01;
              color: @base05;
            }

            headerbar {
              background-color: @base00;
              color: @base05;
            }

            scrollbar slider {
              background-color: @base03;
            }

            scrollbar slider:hover {
              background-color: @base04;
            }

            selection {
              background-color: @base02;
              color: @base05;
            }

            :disabled {
              color: @base03;
            }

            .error {
              color: @base08;
            }

            .warning {
              color: @base09;
            }

            .success {
              color: @base0B;
            }

            .info {
              color: @base0C;
            }

            link,
            button.link {
              color: @base0D;
            }
          '';

          # qt6ct
          ".config/qt6ct/qt6ct.conf".text = ''
            [Appearance]
            style=Fusion
            icon_theme=Adwaita

            [Fonts]
            fixed="monospace,10,-1,5,50,0,0,0,0,0"
            general="Sans Serif,10,-1,5,50,0,0,0,0,0"

            [Interface]
            activate_item_on_single_click=1
            double_click_interval=400
            gui_effects=@Invalid()
            menus_have_icons=1
            show_shortcuts_in_context_menus=true
            stylesheets=@Invalid()
            toolbutton_style=4
            underline_shortcut=1
            wheel_scroll_lines=3
          '';

          # qt5ct
          ".config/qt5ct/qt5ct.conf".text = ''
            [Appearance]
            style=Fusion
            icon_theme=Adwaita

            [Fonts]
            fixed="monospace,10,-1,5,50,0,0,0,0,0"
            general="Sans Serif,10,-1,5,50,0,0,0,0,0"

            [Interface]
            activate_item_on_single_click=1
            double_click_interval=400
            gui_effects=@Invalid()
            menus_have_icons=1
            show_shortcuts_in_context_menus=true
            toolbutton_style=4
            underline_shortcut=1
            wheel_scroll_lines=3
          '';
        };
      };

      environment.sessionVariables = {
        QT_QPA_PLATFORMTHEME = "qt6ct";
        QT_STYLE_OVERRIDE = "Fusion";
      };
    };
}
