{ config, ... }:
{
  flake.nixosModules.sioyek =
    { pkgs, ... }:
    let
      pdfScript = (
        pkgs.writeShellScriptBin "pdf" ''
          set -euo pipefail

          FD="${pkgs.fd}/bin/fd"
          FZF="${pkgs.fzf}/bin/fzf"
          SORT="${pkgs.coreutils}/bin/sort"
          SIOYEK="${pkgs.sioyek}/bin/sioyek"
          TMUX="${pkgs.tmux}/bin/tmux"
          REALPATH="${pkgs.coreutils}/bin/realpath"
          BASENAME="${pkgs.coreutils}/bin/basename"

          DIRS=(
            "$HOME/documents"
          )

          list_documents() {
            "$FD" \
              --absolute-path \
              --type f \
              --max-depth 8 \
              \( -e pdf -o -e epub -o -e djvu \) \
              "''${DIRS[@]}" 2>/dev/null |
              "$SORT" -u |
              while IFS= read -r path; do
                name="$("$BASENAME" "$path")"
                dir="$(dirname "$path" | sed "s#$HOME#~#")"

                printf '%s\t%s\t%s\n' \
                  "$name" \
                  "$dir" \
                  "$path"
              done
          }

          open_sioyek_tmux() {
            local file="$1"
            local session="pdf"

            if ! "$TMUX" has-session -t "$session" 2>/dev/null; then
              "$TMUX" new-session \
                -d \
                -s "$session" \
                -n viewer \
                -c "$HOME"
            fi

            "$TMUX" list-windows -t "$session" |
              grep -q "viewer" || \
              "$TMUX" new-window \
                -d \
                -t "$session" \
                -n viewer \
                -c "$HOME"

            "$TMUX" send-keys \
              -t "$session:viewer" \
              "$SIOYEK $(printf '%q' "$file")" \
              C-m

            "$TMUX" display-message \
              "Opened ''${file##*/}"
          }

          cleanup() {
            unset FZF_DEFAULT_OPTS
          }

          trap cleanup EXIT INT TERM

          if [[ $# -gt 0 ]]; then
            selected="$("$REALPATH" "$1")"
          else
            selected="$(
              mapfile -t entries < <(list_documents)

              ((''${#entries[@]} > 0)) || exit 0

              printf '%s\n' "''${entries[@]}" |
                "$FZF" \
                  --delimiter=$'\t' \
                  --with-nth=1,2 \
                  --layout=reverse \
                  --height=50% \
                  --border \
                  --preview '
                    file=$(echo {} | cut -f3)
                    if command -v pdfinfo >/dev/null 2>&1; then
                      pdfinfo "$file" 2>/dev/null | head -15
                    fi
                  ' |
                cut -f3
            )"

            [[ -n "$selected" ]] || exit 0
          fi

          selected="$("$REALPATH" "$selected")"

          if [[ -n "''${TMUX:-}" ]]; then
            open_sioyek_tmux "$selected"
          else
            exec "$SIOYEK" "$selected"
          fi
        ''
      );
    in
    {
      environment.systemPackages = [
        pkgs.sioyek
        pdfScript
      ];
      environment.sessionVariables = {
        "QT_QPA_PLATFORM" = "xcb";
      };
      hjem.users.abhi = {
        files.".config/sioyek/prefs_user.config".source = ./prefs_user.config;
        files.".config/sioyek/keys_user.config".source = ./keys_user.config;
      };
      # environment.etc."sioyek/prefs_user.config".source =
      #   ./prefs_user.config;
      #
      # environment.etc."sioyek/keys_user.config".source =
      #   ./keys_user.config;
      #
      # system.activationScripts.sioyekConfig.text = ''
      #   mkdir -p /home/abhi/.config/sioyek
      #   ln -sfn /etc/sioyek/prefs_user.config \
      #     /home/abhi/.config/sioyek/prefs_user.config
      #   ln -sfn /etc/sioyek/keys_user.config \
      #     /home/abhi/.config/sioyek/keys_user.config
      # '';
    };
}
