{
  description = "NixOS System Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf.url = "github:notashelf/nvf";
  };

  outputs = { self, nixpkgs, home-manager, nvf, ... }: {
    nixosConfigurations = {
      ThinkPad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
	  nvf.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.felix = import ./home.nix;
              backupFileExtension = "backup";
            };
          }
        ];
      };

      
      exampleIso = nixpkgs.lib.nixosSystem {
	modules = [
	  ./hosts/isoimage/configuration.nix
	];
      };


    };
  };
}
