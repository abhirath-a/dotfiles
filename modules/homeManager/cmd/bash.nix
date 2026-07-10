{ pkgs, ... }:
{
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      export PS1="\[\e[38;5;75m\]\w \[\e[38;5;189m\]\$ \[\e[0m\]"
      if command -v ${pkgs.tmux}/bin/tmux >/dev/null &&
        ! ${pkgs.tmux}/bin/tmux has-session -t background 2>/dev/null; then
        ${pkgs.tmux}/bin/tmux new-session -d -s background -n home
      fi
    '';
  };
}
