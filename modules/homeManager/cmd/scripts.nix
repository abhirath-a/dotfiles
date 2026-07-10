{ pkgs, ... }:
{
  scripts = [
    (pkgs.writeShellScriptBin "amc" ''
      set -euo pipefail

      year=$(( RANDOM % 27 + 2000 ))
      question=$(( RANDOM % 25 + 1 ))

      options_type=("10" "12")
      options_letter=("A" "B")

      contest_type=''${options_type[$(( RANDOM % 2 ))]}
      letter_type=''${options_letter[$(( RANDOM % 2 ))]}

      url="https://artofproblemsolving.com/wiki/index.php?title=''${year}_AMC_''${contest_type}''${letter_type}_Problems/Problem_''${question}"

      exec ${pkgs.xdg-utils}/bin/xdg-open "$url"
    '')
    (pkgs.writeShellScriptBin "pdf" ''
      set -euo pipefail

      FD="${pkgs.fd}/bin/fd"
      FZF="${pkgs.fzf}/bin/fzf"
      SORT="${pkgs.coreutils}/bin/sort"
      SIOYEK="${pkgs.sioyek}/bin/sioyek"
      BASH="${pkgs.bash}/bin/bash"

      DIRS=(
        "$HOME/documents"
      )

      ensure_runner_session() {
        local session="$1"

        if ${pkgs.tmux}/bin/tmux has-session -t "$session" 2>/dev/null; then
          return
        fi

        ${pkgs.tmux}/bin/tmux new-session \
          -d \
          -s "$session" \
          -n home \
          -c "$HOME" \
          "$BASH"
      }

      list_documents() {
        # REMOVED --base-directory so FD outputs absolute paths directly
        "$FD" . "''${DIRS[@]}" \
          --max-depth 2 \
          -e pdf \
          -e epub \
          -e djvu \
          |
          "$SORT" -uf |
          while IFS= read -r path; do
            # This correctly shows just the filename in FZF, but keeps the absolute path
            printf '%s\t%s\n' "''${path##*/}" "$path"
          done
      }

      if [[ $# -gt 0 ]]; then
        selected="$1"
      else
        selected="$(
          list_documents |
            "$FZF" \
              --delimiter=$'\t' \
              --with-nth=1 |
            cut -f2
        )"

        [[ -n "$selected" ]] || exit 0
      fi

      if [[ -n "''${TMUX_PANE:-}" ]]; then
        session="''${TMUX_RUNNER_SESSION:-background}"

        ensure_runner_session "$session"

        ${pkgs.tmux}/bin/tmux new-window \
          -d \
          -t "$session:" \
          -n pdf \
          -c "$HOME" \
          "$SIOYEK" "$selected"

        ${pkgs.tmux}/bin/tmux display-message "Opened ''${selected##*/}"
      else
        exec "$SIOYEK" "$selected"
      fi
    '')

    # vestibule-esque
    (pkgs.writeShellScriptBin "work-mode" ''
            set -euo pipefail

            HOSTS_FILE="/var/lib/dnsmasq/work-mode-hosts"
            BEGIN_MARKER="# BEGIN WORK MODE DNS BLOCK"
            END_MARKER="# END WORK MODE DNS BLOCK"
            IPV4_BLOCK="0.0.0.0"
            IPV6_BLOCK="::1"

            DOMAINS=(
              youtube.com
              www.youtube.com
              m.youtube.com
              music.youtube.com
              tv.youtube.com
              youtu.be
              www.youtu.be
              youtube-nocookie.com
              www.youtube-nocookie.com
              youtubei.googleapis.com
              ytimg.com
              www.ytimg.com
              i.ytimg.com
              s.ytimg.com
              googlevideo.com
              www.googlevideo.com
              discord.com
              www.discord.com
              canary.discord.com
              ptb.discord.com
              discord.gg
              www.discord.gg
              gateway.discord.gg
              discordapp.com
              www.discordapp.com
              cdn.discordapp.com
              media.discordapp.net
              substack.com
              www.substack.com
              app.substack.com
              reader.substack.com
              open.substack.com
              substackcdn.com
              substack-post-media.s3.amazonaws.com
              www.reddit.com
              reddit.com
              redditmedia.com
              redditstatic.com
              redd.it
              instagram.com
              www.instagram.com
              cdninstagram.com
            )

            usage() {
cat <<EOF
Usage: $(basename "$0") [on|off|toggle|status|domains]

Toggles a marked DNS-resolution block in $HOSTS_FILE via dnsmasq.
Without an argument, defaults to: toggle.
EOF
            }

            is_enabled() {
              [[ -f "$HOSTS_FILE" ]] &&
                ${pkgs.gnugrep}/bin/grep -Fxq "$BEGIN_MARKER" "$HOSTS_FILE"
            }

            print_domains() {
              printf '%s\n' "''${DOMAINS[@]}"
            }

            strip_work_mode_block() {
              if [[ -f "$HOSTS_FILE" ]]; then
                ${pkgs.gawk}/bin/awk \
                  -v begin="$BEGIN_MARKER" \
                  -v end="$END_MARKER" '
                    $0 == begin { skipping = 1; next }
                    $0 == end { skipping = 0; next }
                    !skipping { print }
                  ' "$HOSTS_FILE"
              fi
            }

            append_work_mode_block() {
              printf '\n%s\n' "$BEGIN_MARKER"
              printf '# Managed by work-mode; run `work-mode off` to remove.\n'

              for domain in "''${DOMAINS[@]}"; do
                printf '%s\t%s\n' "$IPV4_BLOCK" "$domain"
                printf '%s\t%s\n' "$IPV6_BLOCK" "$domain"
              done

              printf '%s\n' "$END_MARKER"
            }

            reload_dnsmasq() {
              if ! sudo ${pkgs.systemd}/bin/systemctl kill -s HUP dnsmasq 2>/dev/null; then
                sudo ${pkgs.systemd}/bin/systemctl reload dnsmasq
              fi
            }

            set_work_mode() {
              local state="$1"
              local tmp_file

              tmp_file="$(${pkgs.coreutils}/bin/mktemp /tmp/work-mode-hosts.XXXXXX)"
              trap 'rm -f "$tmp_file"' EXIT

              strip_work_mode_block > "$tmp_file"

              if [[ "$state" == "on" ]]; then
                append_work_mode_block >> "$tmp_file"
              fi

              sudo cp "$tmp_file" "$HOSTS_FILE"
              sudo chmod 0644 "$HOSTS_FILE"

              reload_dnsmasq
            }

            action="''${1:-toggle}"

            case "$action" in
              on)
                set_work_mode on
                echo "Work mode is on. Blocked ''${#DOMAINS[@]} hostnames."
                ;;
              off)
                set_work_mode off
                echo "Work mode is off."
                ;;
              toggle)
                if is_enabled; then
                  set_work_mode off
                  echo "Work mode is off."
                else
                  set_work_mode on
                  echo "Work mode is on. Blocked ''${#DOMAINS[@]} hostnames."
                fi
                ;;
              status)
                if is_enabled; then
                  echo "Work mode is on."
                else
                  echo "Work mode is off."
                fi
                ;;
              domains)
                print_domains
                ;;
              -h|--help|help)
                usage
                ;;
              *)
                usage >&2
                exit 2
                ;;
            esac
    '')

    (pkgs.writeShellScriptBin "ts" ''
      set -euo pipefail

          DIRS=(
            "$HOME"
            "$HOME/documents"
            "$HOME/documents/projects"
            "$HOME/projects"
            "$HOME/src"
            "$HOME/.config/nixos"
          )

          if [[ $# -eq 1 ]]; then
            selected="$1"
          else
            selected=$(
              ${pkgs.fd}/bin/fd \
                --type d \
                --hidden \
                --exclude .git \
                --max-depth 2 \
                . "''${DIRS[@]}" 2>/dev/null |
              ${pkgs.coreutils}/bin/sort -u |
              ${pkgs.fzf}/bin/fzf \
                --height 40% \
                --reverse \
                --border
            )
          fi

          [[ -z "''${selected:-}" ]] && exit 0

          selected="$(${pkgs.coreutils}/bin/realpath "$selected")"

          session_name=$(
            echo "$selected" |
              sed "s#$HOME#~#" |
              tr '/.' '__'
          )

          if ! ${pkgs.tmux}/bin/tmux has-session -t "$session_name" 2>/dev/null; then
            ${pkgs.tmux}/bin/tmux new-session \
              -d \
              -s "$session_name" \
              -c "$selected" \
              -n editor

            ${pkgs.tmux}/bin/tmux send-keys \
              -t "$session_name:editor" \
              "''${EDITOR:-nvim}" \
              C-m

            # Added -d here so the shell window doesn't steal focus from the editor
            ${pkgs.tmux}/bin/tmux new-window \
              -d \
              -t "$session_name" \
              -n shell \
              -c "$selected"
          fi

          if [[ -n "''${TMUX:-}" ]]; then
            ${pkgs.tmux}/bin/tmux switch-client -t "$session_name"
          else
            ${pkgs.tmux}/bin/tmux attach-session -t "$session_name"
          fi
    '')

    (pkgs.writeShellScriptBin "open-repo" ''
      set -euo pipefail

      cd "$(${pkgs.tmux}/bin/tmux run "echo #{pane_start_path}")"

      if ! url=$(${pkgs.git}/bin/git remote get-url origin 2>/dev/null); then
        echo "error: not a repo"
        exit 1
      fi

      if [[ $url == ssh://* ]]; then
        url="''${url#ssh://}"
        url="''${url#git@}"
        url="https://$url"
      elif [[ $url == git@* ]]; then
        url="''${url#git@}"
        url="''${url/:/\/}" 
        url="https://$url"
      fi

      url="''${url%.git}"

      if [[ $url == *github.com* || $url == *codeberg.org* || $url == *tangled.org* ]]; then
        ${pkgs.xdg-utils}/bin/xdg-open "$url"
      else
        echo "repo not on known provider"
        exit 1
      fi
    '')
  ];
}
