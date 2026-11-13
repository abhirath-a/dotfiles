
{ ... }:
let
  domains = [
    "youtube.com"
    "www.youtube.com"
    "m.youtube.com"
    "music.youtube.com"
    "tv.youtube.com"
    "youtu.be"
    "www.youtu.be"
    "youtube-nocookie.com"
    "www.youtube-nocookie.com"
    "youtubei.googleapis.com"
    "ytimg.com"
    "www.ytimg.com"
    "i.ytimg.com"
    "s.ytimg.com"
    "googlevideo.com"
    "www.googlevideo.com"
    "discord.com"
    "www.discord.com"
    "canary.discord.com"
    "ptb.discord.com"
    "discord.gg"
    "www.discord.gg"
    "gateway.discord.gg"
    "discordapp.com"
    "www.discordapp.com"
    "cdn.discordapp.com"
    "media.discordapp.net"
    "substack.com"
    "www.substack.com"
    "app.substack.com"
    "reader.substack.com"
    "open.substack.com"
    "substackcdn.com"
    "substack-post-media.s3.amazonaws.com"
    "reddit.com"
    "www.reddit.com"
    "redditmedia.com"
    "redditstatic.com"
    "redd.it"
    "instagram.com"
    "www.instagram.com"
    "cdninstagram.com"
  ];

  mkModule = isDarwin:
    { pkgs, ... }:
    let
      hostsFile =
        if isDarwin then
          "/etc/hosts"
        else
          "/var/lib/dnsmasq/work-mode-hosts";

      workMode = pkgs.writeShellScriptBin "work-mode" ''
        set -euo pipefail

        HOSTS_FILE="${hostsFile}"
        BEGIN="# BEGIN WORK MODE"
        END="# END WORK MODE"

        DOMAINS=(
          ${builtins.concatStringsSep "\n          " domains}
        )

        usage() {
          echo "Usage: work-mode [on|off|toggle|status|domains]"
        }

        enabled() {
          [[ -f "$HOSTS_FILE" ]] &&
            grep -Fxq "$BEGIN" "$HOSTS_FILE"
        }

        strip_block() {
          awk -v begin="$BEGIN" -v end="$END" '
            $0 == begin { skip = 1; next }
            $0 == end { skip = 0; next }
            !skip { print }
          ' "$HOSTS_FILE"
        }

        append_block() {
          echo "$BEGIN"

          for domain in "''${DOMAINS[@]}"; do
            printf '0.0.0.0 %s\n' "$domain"
            printf '::1 %s\n' "$domain"
          done

          echo "$END"
        }

        reload_dns() {
          ${if isDarwin then ''
            sudo /usr/bin/dscacheutil -flushcache
            sudo /usr/bin/killall -HUP mDNSResponder
          '' else ''
            sudo /run/current-system/sw/bin/systemctl \
              kill -s HUP dnsmasq
          ''}
        }

        set_mode() {
          local state="$1"
          local tmp

          tmp="$(mktemp)"
          trap 'rm -f "$tmp"' EXIT

          strip_block > "$tmp"

          if [[ "$state" == "on" ]]; then
            append_block >> "$tmp"
          fi

          sudo cp "$tmp" "$HOSTS_FILE"
          sudo chmod 0644 "$HOSTS_FILE"

          reload_dns
        }

        action="''${1:-toggle}"

        case "$action" in
          on)
            set_mode on
            echo "Work mode enabled."
            ;;
          off)
            set_mode off
            echo "Work mode disabled."
            ;;
          toggle)
            if enabled; then
              set_mode off
              echo "Work mode disabled."
            else
              set_mode on
              echo "Work mode enabled."
            fi
            ;;
          status)
            if enabled; then
              echo "Work mode is on."
            else
              echo "Work mode is off."
            fi
            ;;
          domains)
            printf '%s\n' "''${DOMAINS[@]}"
            ;;
          -h|--help|help)
            usage
            ;;
          *)
            usage >&2
            exit 2
            ;;
        esac
      '';
    in
    {
      environment.systemPackages = [ workMode ];
    };
in
{
  flake.nixosModules.dnsmasq =
    { ... }:
    {
      imports = [ (mkModule false) ];

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
    };

  flake.darwinModules.dnsmasq = mkModule true;
}

