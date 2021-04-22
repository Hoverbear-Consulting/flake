{
  description = "Hoverbear's Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    lx2k-nix.url = "github:hoverbear-consulting/lx2k-nix/flake";
    nixos-wsl.url = "github:hoverbear-consulting/NixOS-WSL/modularize";
  };

  outputs = { self, nixpkgs, lx2k-nix, nixos-wsl }: {

    packages = {
      "aarch64-linux" = let
        pkgs = import nixpkgs {
          system = "aarch64-linux";
        };
      in {
        gizmoUefi = lx2k-nix.packages.aarch64-linux.lx2k-3200.uefi;
        gizmoIsoImage = self.nixosConfigurations.gizmoIsoImage.config.system.build.isoImage;
      };
      "x86_64-linux" = let
        pkgs = import nixpkgs {
          system = "x86_64-linux";
        };
      in {
        architectIsoImage = self.nixosConfigurations.architectIsoImage.config.system.build.isoImage;
        wslTarball = self.nixosConfigurations.wsl.config.system.build.tarball;
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
          trait.jetbrains
          trait.postgres
          user.ana
        ];
      };
    in with self.nixosModules; {
      gizmo = nixpkgs.lib.nixosSystem {
        inherit (gizmoBase) system;
        modules = gizmoBase.modules ++ [
          platform.gizmo
        ];
      };
      gizmoIsoImage = nixpkgs.lib.nixosSystem {
        inherit (gizmoBase) system;
        modules = gizmoBase.modules ++ [
          platform.iso-minimal
        ];
      };
      architect = nixpkgs.lib.nixosSystem {
        inherit (architectBase) system;
        modules = architectBase.modules ++ [
          platform.architect
          trait.workstation
        ];
      };
      architectIsoImage = nixpkgs.lib.nixosSystem {
        inherit (architectBase) system;
        modules = architectBase.modules ++ [
          platform.iso
        ];
      };
      wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          trait.base
          trait.ide
          trait.jetbrains
          nixos-wsl.nixosModule
          ({ pkgs, lib, ... }: {
            boot.wsl.enable = true;
            boot.wsl.user = "ana";
          })
        ];
      };
    };

    nixosModules = {
      platform.container = ./platform/container.nix;
      platform.gizmo = ./platform/gizmo.nix;
      platform.architect = ./platform/architect.nix;
      platform.iso-minimal = "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix";
      platform.iso = "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-plasma5.nix";
      trait.base = ./trait/base.nix;
      trait.machine = ./trait/machine.nix;
      trait.ide = ./trait/ide.nix;
      trait.jetbrains = ./trait/jetbrains.nix;
      trait.hardened = ./trait/hardened.nix;
      trait.postgres = ./trait/postgres.nix;
      # This trait is unfriendly to being bundled with platform-iso
      trait.workstation = ./trait/workstation.nix;
      user.ana = ./user/ana.nix;
      # container-postgres = import ./container/postgres.nix { inherit self; };
    };
  };
}
