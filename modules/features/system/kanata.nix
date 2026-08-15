{
  flake.nixosModules.kanata =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        kanata
      ];

      services.kanata = {
        enable = true;
        keyboards.input.config = ''
          (defsrc
            caps
          )

          (defalias
            escctrl (tap-hold 500 500 esc lctl)
          )

          (deflayer base
            @escctrl
          )
        '';
      };
    };
}
