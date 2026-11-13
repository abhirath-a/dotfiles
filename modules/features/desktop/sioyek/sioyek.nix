
{ ... }:
let
  sioyekModule =
    { pkgs, ... }:
    let
      isDarwin = pkgs.stdenv.isDarwin;

      configDir =
        if isDarwin then
          "Library/Application Support/sioyek"
        else
          ".config/sioyek";

      pdfScript = pkgs.writeShellApplication {
        name = "pdf";

        runtimeInputs = with pkgs; [
          fd
          fzf
          coreutils
          poppler-utils
          sioyek
        ];

        text = ''
          set -euo pipefail

          DIRS=(
            "$HOME/Documents"
            "$HOME/documents"
          )

          list_documents() {
            for dir in "''${DIRS[@]}"; do
              [[ -d "$dir" ]] || continue

              fd \
                --absolute-path \
                --type f \
                --max-depth 8 \
                -e pdf \
                -e epub \
                -e djvu \
                "" "$dir"
            done |
              sort -u |
              while IFS= read -r path; do
                name="$(basename "$path")"
                dir="$(dirname "$path")"
                dir="~''${dir#"$HOME"}"

                printf '%s\t%s\t%s\n' \
                  "$name" "$dir" "$path"
              done
          }

          open_document() {
            local file="$1"

            if [[ -n "''${TMUX:-}" ]]; then
              nohup sioyek "$file" \
                >/dev/null 2>&1 </dev/null &

              disown

              tmux display-message \
                "Opened ''${file##*/}"
            else
              exec sioyek "$file"
            fi
          }

          if [[ $# -gt 0 ]]; then
            selected="$(realpath "$1")"
          else
            selected="$(
              list_documents |
                fzf \
                  --delimiter=$'\t' \
                  --with-nth=1,2 \
                  --layout=reverse \
                  --height=50% \
                  --border \
                  --preview \
                    'pdfinfo {3} 2>/dev/null | head -15'
            )" || exit 0

            [[ -n "$selected" ]] || exit 0

            selected="$(printf '%s\n' "$selected" | cut -f3)"
          fi

          [[ -f "$selected" ]] || {
            echo "File not found: $selected" >&2
            exit 1
          }

          open_document "$selected"
        '';
      };
    in
    {
      environment.systemPackages = [
        pkgs.sioyek
        pdfScript
      ];

      hjem.users.abhi.files = {
        "${configDir}/prefs_user.config".source =
          ./prefs_user.config;

        "${configDir}/keys_user.config".source =
          ./keys_user.config;
      };
    };
in
{
  flake.nixosModules.sioyek = sioyekModule;
  flake.darwinModules.sioyek = sioyekModule;
}

