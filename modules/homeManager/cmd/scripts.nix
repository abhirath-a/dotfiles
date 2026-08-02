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


      # usage() {
      # cat <<EOF
      # Usage: $(basename "$0") [on|off|toggle|status|domains]
      #
      # Toggles a marked DNS-resolution block in $HOSTS_FILE via dnsmasq.
      # Without an argument, defaults to: toggle.
      # EOF
      # }

      is_enabled() {
        [[ -f "$HOSTS_FILE" ]] &&
          ${pkgs.ripgrep}/bin/rg -Fxq "$BEGIN_MARKER" "$HOSTS_FILE"
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

      FD="${pkgs.fd}/bin/fd"
      FZF="${pkgs.fzf}/bin/fzf"
      SORT="${pkgs.coreutils}/bin/sort"
      REALPATH="${pkgs.coreutils}/bin/realpath"
      SHA256SUM="${pkgs.coreutils}/bin/sha256sum"
      TMUX="${pkgs.tmux}/bin/tmux"

      DIRS=(
        "$HOME"
        "$HOME/documents"
        "$HOME/documents/projects"
        "$HOME/projects"
        "$HOME/src"
        "$HOME/.config/nixos"
      )

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

      if [[ $# -eq 1 ]]; then
        selected="$1"
      else
        mapfile -t entries < <(list_directories)

        ((''${#entries[@]} > 0)) || exit 0

        selected="$(
          printf '%s\n' "''${entries[@]}" |
            "$FZF" \
              --height 40% \
              --reverse \
              --border \
              --preview 'ls -la {}'
        )"
      fi

      [[ -n "''${selected:-}" ]] || exit 0

      selected="$("$REALPATH" "$selected")"

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
