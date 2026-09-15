{ self, inputs, ... }:
{
  flake.nixosModules.tmux =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.fd
        pkgs.fzf
        pkgs.coreutils
        self.packages.${pkgs.stdenv.hostPlatform.system}.tmux
        self.packages.${pkgs.stdenv.hostPlatform.system}.session
      ];
    };

  perSystem =
    { pkgs, ... }:
    {
      packages = {
        tmux = inputs.wrapper-modules.wrappers.tmux.wrap {
          inherit pkgs;
          package = pkgs.tmux;

          configBefore = builtins.readFile ./tmux.conf;
        };
        session = (
          pkgs.writeShellScriptBin "ts" ''
            set -uo pipefail

            FD="${pkgs.fd}/bin/fd"
            FZF="${pkgs.fzf}/bin/fzf"
            SORT="${pkgs.coreutils}/bin/sort"
            REALPATH="${pkgs.coreutils}/bin/realpath"
            SHA256SUM="${pkgs.coreutils}/bin/sha256sum"
            TMUX="${pkgs.tmux}/bin/tmux"

            RAW_DIRS=(
              "$HOME"
              "$HOME/documents"
              "$HOME/documents/projects"
              "$HOME/projects"
              "$HOME/src"
              "$HOME/.config/nixos"
            )

            # Filter only existing directories to prevent fd/set -e failures
            DIRS=()
            for d in "''${RAW_DIRS[@]}"; do
              [[ -d "$d" ]] && DIRS+=("$d")
            done

            IGNORES=(
              ".git"
              "node_modules"
              "target"
              ".direnv"
              "result"
              ".cache"
              ".venv"
              "venv"
            )

            EDITOR_CMD="''${EDITOR:-nvim}"

            list_directories() {
              if ((''${#DIRS[@]} == 0)); then
                return 0
              fi
              "$FD" \
                --type d \
                --hidden \
                --max-depth 3 \
                "''${DIRS[@]}" \
                "''${IGNORES[@]/#/--exclude=}" 2>/dev/null |
                "$SORT" -u
            }

            session_name() {
              local path="$1"
              printf '%s' "$path" |
                "$SHA256SUM" |
                cut -c1-12
            }

            expand_path() {
              local path="$1"
              if [[ "$path" == "~/"* ]]; then
                path="$HOME/''${path#~/}"
              elif [[ "$path" == "~" ]]; then
                path="$HOME"
              fi
              "$REALPATH" "$path"
            }

            if [[ $# -eq 1 ]]; then
              selected="$(expand_path "$1")"
            elif [[ $# -gt 1 ]]; then
              echo "usage: ts [directory]" >&2
              exit 2
            else
              mapfile -t entries < <(list_directories)

              ((''${#entries[@]} > 0)) || { echo "No directories found to search." >&2; exit 0; }

              selected="$(
                printf '%s\n' "''${entries[@]}" |
                  "$FZF" \
                    --height 40% \
                    --reverse \
                    --border \
                    --preview 'ls -la {}'
              )"

              [[ -n "''${selected:-}" ]] || exit 0

              selected="$("$REALPATH" "$selected")"
            fi

            name="$(session_name "$selected")"

            if ! "$TMUX" has-session -t "$name" 2>/dev/null; then
              "$TMUX" new-session \
                -d \
                -s "$name" \
                -c "$selected" \
                -n editor

              "$TMUX" send-keys \
                -t "$name:editor" \
                "$EDITOR_CMD" \
                C-m

              "$TMUX" new-window \
                -d \
                -t "$name" \
                -n shell \
                -c "$selected"
            fi

            if [[ -n "''${TMUX:-}" ]]; then
              "$TMUX" switch-client -t "$name"
            else
              exec "$TMUX" attach-session -t "$name"
            fi
          ''
        );
      };
    };
}
