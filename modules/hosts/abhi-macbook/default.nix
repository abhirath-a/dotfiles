{ self, inputs, ... }: {
  flake.darwinConfigurations.abhi-macbook = inputs.nix-darwin.lib.darwinSystem {
    modules = with self.darwinModules;[
      abhi-macbookConfiguration
      ghostty
      hjem
      kanata
      aerospace
      spotify
      sioyek
      yazi
    ];
  };
}
