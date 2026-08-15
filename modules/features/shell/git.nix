{ self, inputs, ... }: {
  flake.nixosModules.git =
    { pkgs, lib, ... }:
    let
      openRepo = (
        pkgs.writeShellScriptBin "open-repo" ''
          set -euo pipefail

          cd "$(${pkgs.tmux}/bin/tmux run "echo #{pane_start_path}")"

          if ! url=$(${pkgs.git}/bin/git remote get-url origin 2>/dev/null); then
            echo "error: not a repo"
            exit 1
          fi

          case "$url" in
            git@*)
              # git@github.com:user/repo.git
              url="''${url#git@}"
              url="''${url/:/\/}"
              url="https://$url"
              ;;

            ssh://*)
              # ssh://git@github.com/user/repo.git
              url="''${url#ssh://}"
              url="''${url#git@}"
              url="https://$url"
              ;;

            git+ssh://*)
              # git+ssh://git@codeberg.org/user/repo.git
              url="''${url#git+ssh://}"
              url="''${url#git@}"
              url="https://$url"
              ;;
          esac

          url="''${url%.git}"

          case "$url" in
            https://github.com/*|https://codeberg.org/*|https://tangled.org/*)
              ${pkgs.xdg-utils}/bin/xdg-open "$url"
              ;;

            *)
              echo "error: repo not on known provider"
              exit 1
              ;;
          esac
        ''
      );
    in
    {
      programs.git = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.git;
      };
      environment.systemPackages = [
        openRepo
      ];
    };

  perSystem = { pkgs, ... }: {
    packages.git = inputs.wrapper-modules.wrappers.git.wrap {
      inherit pkgs;
      settings = {
        user.name = "Abhi";
        user.email = "hello@abhirath.net";
        commit.gpgsign = true;
        gpg.format = "ssh";
        user.signingkey = "~/.ssh/id_ed25519.pub";
      };
    };
  };
}
