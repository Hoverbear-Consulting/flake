{
  description = "Hoverbear's Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl = {
      url = "github:hoverbear-consulting/NixOS-WSL/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-wsl, home-manager }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in
    {
      overlays.default = final: prev: {
        neovimConfigured = final.callPackage ./packages/neovimConfigured { };
        vscodeConfigured = final.callPackage ./packages/vscode.nix { };
      };

      packages = forAllSystems
        (system:
          let
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ self.overlays.default ];
              config.allowUnfree = true;
            };
          in
          {
            inherit (pkgs) neovimConfigured vscodeConfigured;

            unsafe-bootstrap = pkgs.callPackage ./packages/unsafe-bootstrap { };
          });

      devShells = forAllSystems
        (system:
          let
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ self.overlays.default ];
            };
          in
          {
            default = pkgs.mkShell
              {
                inputsFrom = with pkgs; [ ];
                buildInputs = with pkgs; [
                  nixpkgs-fmt
                ];
              };
          });

      homeConfigurations = forAllSystems
        (system:
          let
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ self.overlays.default ];
            };
          in
          {
            ana = home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [
                ./users/ana/home.nix
              ];
            };
          }
        );

      nixosConfigurations =
        let
          # Shared config between both the liveimage and real system
          aarch64Base = {
            system = "aarch64-linux";
            modules = with self.nixosModules; [
              home-manager.nixosModules.home-manager
              traits.overlay
              traits.base
              services.openssh
            ];
          };
          x86_64Base = {
            system = "x86_64-linux";
            modules = with self.nixosModules; [
              home-manager.nixosModules.home-manager
              traits.overlay
              traits.base
              services.openssh
            ];
          };
        in
        with self.nixosModules; {
          x86_64IsoImage = nixpkgs.lib.nixosSystem {
            inherit (x86_64Base) system;
            modules = x86_64Base.modules ++ [
              platforms.iso
            ];
          };
          aarch64IsoImage = nixpkgs.lib.nixosSystem {
            inherit (aarch64Base) system;
            modules = aarch64Base.modules ++ [
              platforms.iso
              {
                config = {
                  virtualisation.vmware.guest.enable = nixpkgs.lib.mkForce false;
                  services.xe-guest-utilities.enable = nixpkgs.lib.mkForce false;
                };
              }
            ];
          };
          honeycombIsoImage = nixpkgs.lib.nixosSystem {
            inherit (aarch64Base) system;
            modules = aarch64Base.modules ++ [
              platforms.iso
              traits.honeycomb_lx2k
              {
                config = {
                  virtualisation.vmware.guest.enable = nixpkgs.lib.mkForce false;
                  services.xe-guest-utilities.enable = nixpkgs.lib.mkForce false;
                };
              }
            ];
          };
          gizmo = nixpkgs.lib.nixosSystem {
            inherit (aarch64Base) system;
            modules = aarch64Base.modules ++ [
              platforms.gizmo
              traits.honeycomb_lx2k
              traits.machine
              traits.workstation
              traits.hardened
              users.ana
            ];
          };
          architect = nixpkgs.lib.nixosSystem {
            inherit (x86_64Base) system;
            modules = x86_64Base.modules ++ [
              platforms.architect
              traits.machine
              traits.workstation
              traits.hardened
              users.ana
            ];
          };
          nomad = nixpkgs.lib.nixosSystem {
            inherit (x86_64Base) system;
            modules = x86_64Base.modules ++ [
              platforms.nomad
              traits.machine
              traits.workstation
              traits.hardened
              traits.gaming
              users.ana
            ];
          };
          wsl = nixpkgs.lib.nixosSystem {
            inherit (x86_64Base) system;
            modules = x86_64Base.modules ++ [
              nixos-wsl.nixosModule
              platforms.wsl
            ];
          };
        };

      nixosModules = {
        platforms.container = ./platforms/container.nix;
        platforms.wsl = ./platforms/wsl.nix;
        platforms.gizmo = ./platforms/gizmo.nix;
        platforms.architect = ./platforms/architect.nix;
        platforms.nomad = ./platforms/nomad.nix;
        platforms.iso-minimal = "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix";
        platforms.iso = "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix";
        traits.overlay = { nixpkgs.overlays = [ self.overlays.default ]; };
        traits.base = ./traits/base.nix;
        traits.machine = ./traits/machine.nix;
        traits.gaming = ./traits/gaming.nix;
        traits.jetbrains = ./traits/jetbrains.nix;
        traits.hardened = ./traits/hardened.nix;
        traits.sourceBuild = ./traits/source-build.nix;
        traits.honeycomb_lx2k = ./traits/honeycomb_lx2k.nix;
        services.postgres = ./services/postgres.nix;
        services.openssh = ./services/openssh.nix;
        # This trait is unfriendly to being bundled with platform-iso
        traits.workstation = ./traits/workstation.nix;
        users.ana = ./users/ana/system.nix;
      };

      checks = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in
        {
          format = pkgs.runCommand "check-format"
            {
              buildInputs = with pkgs; [ rustfmt cargo ];
            } ''
            ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt --check ${./.}
            touch $out # it worked!
          '';
        });

    };
}
