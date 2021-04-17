{
  description = "Hoverbear's Flake";

  inputs = {
    nixos.url = "github:NixOS/nixpkgs/nixos-unstable";
    lx2k-nix.url = "github:hoverbear/lx2k-nix";
  };

  outputs = { self, nixos, lx2k-nix }: {

    packages = {
      "aarch64-linux" = let
        pkgs = import nixos {
          system = "aarch64-linux";
        };
      in {
        gizmoUefi = lx2k-nix.packages.aarch64-linux.lx2k-3200.uefi;
        gizmoIsoImage = self.nixosConfigurations.gizmoIsoImage.config.system.build.isoImage;
      };
      "x86_64-linux" = let
        pkgs = import nixos {
          system = "x86_64-linux";
        };
      in {
        architectIsoImage = self.nixosConfigurations.architectIsoImage.config.system.build.isoImage;
      };
    };

    nixosConfigurations = let
      gizmoBase = {
        system = "aarch64-linux";
        modules = with self.nixosModules; [
          lx2k-nix.nixosModules.lx2k
          trait.base
          trait.hardened
          trait.machine
          trait.ide
          trait.postgres
          user.ana
          # container-postgres
        ];
      };
      architectBase = {
        system = "x86_64-linux";
        modules = with self.nixosModules; [
          trait.base
          trait.hardened
          trait.machine
          trait.ide
          trait.postgres
          user.ana
        ];
      };
    in with self.nixosModules; {
      gizmo = nixos.lib.nixosSystem {
        inherit (gizmoBase) system;
        modules = gizmoBase.modules ++ [
          platform.gizmo
        ];
      };
      gizmoIsoImage = nixos.lib.nixosSystem {
        inherit (gizmoBase) system;
        modules = gizmoBase.modules ++ [
          platform.iso-minimal
        ];
      };
      architect = nixos.lib.nixosSystem {
        inherit (architectBase) system;
        modules = architectBase.modules ++ [
          platform.architect
          trait.workstation
        ];
      };
      architectIsoImage = nixos.lib.nixosSystem {
        inherit (architectBase) system;
        modules = architectBase.modules ++ [
          platform.iso
        ];
      };
    };

    nixosModules = let pkgs = nixos; in {
      platform.container = ./platform/container.nix;
      platform.gizmo = ./platform/gizmo.nix;
      platform.architect = ./platform/architect.nix;
      platform.iso-minimal = "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix";
      platform.iso = "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-graphical-plasma5.nix";
      trait.base = ./trait/base.nix;
      trait.machine = ./trait/machine.nix;
      trait.ide = ./trait/ide.nix;
      trait.hardened = ./trait/hardened.nix;
      trait.postgres = ./trait/postgres.nix;
      # This trait is unfriendly to being bundled with platform-iso
      trait.workstation = ./trait/workstation.nix;
      user.ana = ./user/ana.nix;
      # container-postgres = import ./container/postgres.nix { inherit self; };
    };
  };
}
