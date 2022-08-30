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
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
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
              users.ana
            ];
          };
          x86_64Base = {
            system = "x86_64-linux";
            modules = with self.nixosModules; [
              home-manager.nixosModules.home-manager
              traits.overlay
              traits.base
              services.openssh
              users.ana
            ];
          };
        in
        with self.nixosModules; {
          gizmo = nixpkgs.lib.nixosSystem {
            inherit (aarch64Base) system;
            modules = aarch64Base.modules ++ [
              platforms.gizmo
              traits.machine
              traits.workstation
              traits.hardened
            ];
          };
          gizmoIsoImage = nixpkgs.lib.nixosSystem {
            inherit (aarch64Base) system;
            modules = aarch64Base.modules ++ [
              platforms.iso-minimal
            ];
          };
          architect = nixpkgs.lib.nixosSystem {
            inherit (x86_64Base) system;
            modules = x86_64Base.modules ++ [
              platforms.architect
              traits.machine
              traits.workstation
              traits.hardened
            ];
          };
          architectIsoImage = nixpkgs.lib.nixosSystem {
            inherit (x86_64Base) system;
            modules = x86_64Base.modules ++ [
              platforms.iso
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
            ];
          };
          nomadIsoImage = nixpkgs.lib.nixosSystem {
            inherit (x86_64Base) system;
            modules = x86_64Base.modules ++ [
              platforms.iso
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
        platforms.iso = "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-plasma5.nix";
        traits.overlay = { nixpkgs.overlays = [ self.overlays.default ]; };
        traits.base = ./traits/base.nix;
        traits.machine = ./traits/machine.nix;
        traits.gaming = ./traits/gaming.nix;
        traits.jetbrains = ./traits/jetbrains.nix;
        traits.hardened = ./traits/hardened.nix;
        traits.sourceBuild = ./traits/source-build.nix;
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
