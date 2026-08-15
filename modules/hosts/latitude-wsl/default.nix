{ self, inputs, ... }: {
  flake.nixosConfigurations.latitude-wsl = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.latitudeWslConfiguration
      self.nixosModules.user
      self.nixosModules.tmux
      self.nixosModules.bash
      self.nixosModules.git
      self.nixosModules.nvim
      self.nixosModules.hjem
      self.nixosModules.ssh
      self.nixosModules.btop
      self.nixosModules.sops
    ];
  };
}
