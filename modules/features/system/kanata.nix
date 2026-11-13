{ ... }:
{
  flake.nixosModules.kanata =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.kanata ];

      services.kanata = {
        enable = true;

        keyboards.input.config = ''
          (defsrc caps)

          (defalias
            escctrl (tap-hold 500 500 esc lctl)
          )

          (deflayer base
            @escctrl
          )
        '';
      };
    };

  flake.darwinModules.kanata =
    { pkgs, ... }:
    let
      karabinerConfig = {
        title = "Custom keybindings";

        rules = [
          {
            description = "Caps Lock: Escape on tap, Control on hold";

            manipulators = [
              {
                type = "basic";

                from = {
                  key_code = "caps_lock";
                  modifiers.optional = [ "any" ];
                };

                to = [
                  {
                    key_code = "left_control";
                    lazy = true;
                  }
                ];

                to_if_alone = [
                  { key_code = "escape"; }
                ];

                to_if_held_down = [
                  { key_code = "left_control"; }
                ];

                parameters = {
                  "basic.to_if_alone_timeout_milliseconds" = 500;
                  "basic.to_if_held_down_threshold_milliseconds" = 500;
                };
              }
            ];
          }
        ];
      };
    in
    {
      environment.systemPackages = [
        pkgs.karabiner-elements
      ];

      hjem.users.abhi.files.".config/karabiner/assets/complex_modifications/caps.json".source =
        (pkgs.formats.json { }).generate "caps.json" karabinerConfig;
    };
}
