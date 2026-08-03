{ inputs, pkgs, ... }:
{
	imports = [ inputs.home-manager.nixosModules.home-manager ];

	home-manager = {
		extraSpecialArgs = { inherit inputs; };
		useGlobalPkgs = true;
		useUserPackages = true;
 		users.abhi.imports = [
 			./home.nix
 		];
	};

 	networking.hostName = "latitude-wsl";

	users.users.abhi = {
		isNormalUser = true;
		description = "Abhirath Agasanakoppa";
		extraGroups = [
			"networkmanager"
				"wheel"
		];
		shell = pkgs.bashInteractive;
	};

	nixpkgs = {
		overlays = [
			inputs.abhivim.overlays.default
		];
		config.allowUnfree = true;
	};

	nix.settings.experimental-features = [
		"nix-command"
			"flakes"
			"ca-derivations"
	];
	environment.systemPackages = with pkgs; [ vim ];

	services.openssh.enable = true;

	networking.firewall.enable = true;
	system.stateVersion = "25.05";

	wsl.enable = true;
	wsl.defaultUser = "abhi";
}
