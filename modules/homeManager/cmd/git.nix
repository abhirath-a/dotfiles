{ ... }:
{
  programs.git = {
    enable = true;
    userName = "Abhi";
    userEmail = "hello@abhirath.net";
    extraConfig = {
      commit.gpgsign = true;
      gpg.format = "ssh";
      user.signingkey = "~/.ssh/id_ed25519.pub";
    };
  };
}
