{ ... }:
{
  imports = [
    ./btop.nix
    ./direnv.nix
    ./bash.nix
    ./fzf.nix
    ./git.nix
    ./tmux
    ./yazi
  ];
  programs.opencode.enable = true;
}
