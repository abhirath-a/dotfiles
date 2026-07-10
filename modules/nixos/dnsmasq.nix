{ ... }:

{
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
}
