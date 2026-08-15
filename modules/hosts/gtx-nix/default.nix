{ self, inputs, ... }: {
  flake.nixosConfigurations.gtx-nix = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.gtxNixConfiguration
      self.nixosModules.user
      self.nixosModules.sioyek
      self.nixosModules.foot
      self.nixosModules.fuzzel
      self.nixosModules.niri
      self.nixosModules.tmux
      self.nixosModules.bash
      self.nixosModules.git
      self.nixosModules.nvim
      self.nixosModules.dnsmasq
      self.nixosModules.hjem
      self.nixosModules.kanata
      self.nixosModules.ssh
      self.nixosModules.theming
      self.nixosModules.anki
      self.nixosModules.btop
      self.nixosModules.sops
    ];
  };
}
