{
  inputs,
  self,
  ...
}:
{
  flake.nixosModules.spotify =
    { pkgs, lib, ... }:
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      imports = [ inputs.spicetify-nix.nixosModules.spicetify ];
      programs.spicetify = {
        enable = true;
        enabledCustomApps = builtins.attrValues { inherit (spicePkgs.apps) lyricsPlus ncsVisualizer; };
        enabledExtensions = builtins.attrValues {
          inherit (spicePkgs.extensions)
            adblockify
            hidePodcasts
            shuffle
            betterGenres
            ;
        };
        experimentalFeatures = true;
        alwaysEnableDevTools = true;
        colorScheme = "custom";
        theme = spicePkgs.themes.text;
        customColorScheme = {
          text = "${self.theme.base05}";
          subtext = "${self.theme.base05}";
          main = "${self.theme.base00}";
          main-elevated = "${self.theme.base02}";
          highlight = "${self.theme.base02}";
          highlight-elevated = "${self.theme.base03}";
          sidebar = "${self.theme.base01}";
          player = "${self.theme.base04}";
          card = "${self.theme.base03}";
          shadow = "${self.theme.base00}";
          selected-row = "${self.theme.base04}";
          button = "${self.theme.base04}";
          button-active = "${self.theme.base04}";
          button-disabled = "${self.theme.base03}";
          tab-active = "${self.theme.base02}";
          notification = "${self.theme.base02}";
          notification-error = "${self.theme.base08}";
          equalizer = "${self.theme.base0B}";
          misc = "${self.theme.base02}";
        };
      };
    };
}
