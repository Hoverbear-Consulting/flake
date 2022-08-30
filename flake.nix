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
          gizmoBase = {
            system = "aarch64-linux";
            modules = with self.nixosModules; [
              traits.overlay
              traits.base
              traits.hardened
              traits.machine
              traits.tools
              services.openssh
              users.ana
            ];
          };
          architectBase = {
            system = "x86_64-linux";
            modules = with self.nixosModules; [
              traits.overlay
              traits.base
              traits.hardened
              traits.machine
              traits.tools
              services.openssh
              users.ana
            ];
          };
          nomadBase = {
            system = "x86_64-linux";
            modules = with self.nixosModules; [
              home-manager.nixosModules.home-manager
              {
                config = {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.users.ana = ./users/ana/home.nix;
                };
              }
              traits.overlay
              traits.base
              traits.hardened
              traits.machine
              traits.tools
              services.openssh
              users.ana
            ];
          };
        in
        with self.nixosModules; {
          gizmo = nixpkgs.lib.nixosSystem {
            inherit (gizmoBase) system;
            modules = gizmoBase.modules ++ [
              platforms.gizmo
              traits.workstation
            ];
          };
          gizmoIsoImage = nixpkgs.lib.nixosSystem {
            inherit (gizmoBase) system;
            modules = gizmoBase.modules ++ [
              platforms.iso-minimal
            ];
          };
          architect = nixpkgs.lib.nixosSystem {
            inherit (architectBase) system;
            modules = architectBase.modules ++ [
              platforms.architect
              traits.workstation
            ];
          };
          architectIsoImage = nixpkgs.lib.nixosSystem {
            inherit (architectBase) system;
            modules = architectBase.modules ++ [
              platforms.iso
            ];
          };
          nomad = nixpkgs.lib.nixosSystem {
            inherit (nomadBase) system;
            modules = nomadBase.modules ++ [
              platforms.nomad
              traits.workstation
            ];
          };
          nomadIsoImage = nixpkgs.lib.nixosSystem {
            inherit (nomadBase) system;
            modules = nomadBase.modules ++ [
              platforms.iso
            ];
          };
          wsl = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              traits.overlay
              traits.base
              traits.tools
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
        traits.tools = ./traits/tools.nix;
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
