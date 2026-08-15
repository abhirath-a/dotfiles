{
  flake.nixosModules.dnsmasq =
    { pkgs, ... }:
    let
      workModeScript = (
        pkgs.writeShellScriptBin "work-mode" ''
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
        ''
      );
    in
    {
      environment.systemPackages = [
        workModeScript
      ];
      services.dnsmasq = {
        enable = true;
        settings = {
          listen-address = "127.0.0.1";

          addn-hosts = "/var/lib/dnsmasq/work-mode-hosts";

          server = [
            "/ts.net/100.100.100.100"
            "/100.in-addr.arpa/100.100.100.100"
          ];
        };
      };

      systemd.tmpfiles.rules = [
        "d /var/lib/dnsmasq 0755 dnsmasq dnsmasq - -"
        "f /var/lib/dnsmasq/work-mode-hosts 0644 dnsmasq dnsmasq - -"
      ];

      networking.nameservers = [ "127.0.0.1" ];

      security.sudo.extraRules = [
        {
          users = [ "abhi" ];
          commands = [
            {
              command = "/run/current-system/sw/bin/systemctl reload dnsmasq";
              options = [ "NOPASSWD" ];
            }
            {
              command = "/run/current-system/sw/bin/systemctl kill -s HUP dnsmasq";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];
    };
}
