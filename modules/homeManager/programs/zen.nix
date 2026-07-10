{
  pkgs,
  ...
}:
{
  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
    };
    profiles.default = {
      id = 0;
      name = "abhi";
      isDefault = true;
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        bitwarden
        darkreader
        vimium
        sponsorblock
        dearrow
      ];
      extensions.force = true;
      settings = {
        "browser.search.defaultenginename" = "DuckDuckGo";
        "browser.search.order.1" = "DuckDuckGo";
      };
      search = {
        force = true;
        default = "ddg";
        order = [
          "ddg"
        ];
      };
    };
  };
  stylix.targets.zen-browser.enable = false;
}
