{
  flake.nixosModules.bash =
    { pkgs, ... }:
    let
      amc = (
        pkgs.writeShellScriptBin "amc" ''
          set -euo pipefail

          year=$(( RANDOM % 27 + 2000 ))
          question=$(( RANDOM % 25 + 1 ))

          options_type=("10" "12")
          options_letter=("A" "B")

          contest_type=''${options_type[$(( RANDOM % 2 ))]}
          letter_type=''${options_letter[$(( RANDOM % 2 ))]}

          url="https://artofproblemsolving.com/wiki/index.php?title=''${year}_AMC_''${contest_type}''${letter_type}_Problems/Problem_''${question}"

          exec ${pkgs.xdg-utils}/bin/xdg-open "$url"
        ''
      );
    in
    {
      programs.bash = {
        enable = true;

        interactiveShellInit = ''
          export PS1="\[\e[38;5;75m\]\w \[\e[38;5;189m\]\$ \[\e[0m\]"
          eval "$(${pkgs.fzf}/bin/fzf --bash)"
        '';
      };

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
        silent = true;
      };

      environment.systemPackages = [
        pkgs.fzf
        amc
      ];

      environment.sessionVariables = {
        "EDITOR" = "nvim";
        "MANPAGER" = "nvim +Man!";
        "HISTIGNORE" = "exit:cd:ls:bg:fg:history:f:fd:vim";
      };
    };
}
