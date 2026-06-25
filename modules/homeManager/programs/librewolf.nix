{
  pkgs,
  ...
}:
{
  programs.firefox = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
    };
    profiles.default = {
      id = 0;
      name = "default";
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
  stylix.targets.firefox.profileNames = [ "default" ];
  stylix.targets.firefox.colorTheme.enable = true;
}
