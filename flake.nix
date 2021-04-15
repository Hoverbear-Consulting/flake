{
  description = "Hoverbear's Flake";

  inputs = {
    nixos.url = "github:NixOS/nixpkgs/nixos-unstable";
    lx2k-nix.url = "github:hoverbear/lx2k-nix";
  };

  outputs = { self, nixos, lx2k-nix }: {

    packages = {
      "aarch64-linux" = {
        gizmo-uefi = lx2k-nix.packages.aarch64-linux.lx2k-3200.uefi;
        gizmo-isoImage = self.nixosConfigurations.gizmo-isoImage.config.system.build.isoImage;
      };
      "x86_64-linux" = {
        architect-isoImage = self.nixosConfigurations.architect-isoImage.config.system.build.isoImage;
      };
    };

    nixosConfigurations = let
      gizmo-base = {
        system = "aarch64-linux";
        modules = with self.nixosModules; [
          lx2k-nix.nixosModules.lx2k
          trait-base
          trait-hardened
          trait-machine
          trait-ide
          trait-postgres
          user-ana
          # container-postgres
        ];
      };
      architect-base = {
        system = "x86_64-linux";
        modules = with self.nixosModules; [
          trait-base
          trait-hardened
          trait-machine
          trait-workstation
          trait-ide
          trait-postgres
          user-ana
        ];
      };
    in with self.nixosModules; {
      gizmo = nixos.lib.nixosSystem {
        inherit (gizmo-base) system;
        modules = gizmo-base.modules ++ [
          platform-gizmo
        ];
      };
      gizmo-isoImage = nixos.lib.nixosSystem {
        inherit (gizmo-base) system;
        modules = gizmo-base.modules ++ [
          platform-iso-minimal
        ];
      };
      architect = nixos.lib.nixosSystem {
        inherit (architect-base) system;
        modules = architect-base.modules ++ [
          platform-architect
        ];
      };
      architect-isoImage = nixos.lib.nixosSystem {
        inherit (architect-base) system;
        modules = architect-base.modules ++ [
          platform-iso
        ];
      };
    };

    nixosModules = let pkgs = nixos; in {
      platform-container = ./platform/container.nix;
      platform-gizmo = ./platform/gizmo.nix;
      platform-architect = ./platform/architect.nix;
      platform-iso-minimal = { imports = [ "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix" ]; };
      platform-iso = { imports = [ "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-graphical-base.nix" ]; };
      trait-base = ./trait/base.nix;
      trait-machine = ./trait/machine.nix;
      trait-ide = ./trait/ide.nix;
      trait-workstation = ./trait/workstation.nix;
      trait-hardened = ./trait/hardened.nix;
      trait-postgres = ./trait/postgres.nix;
      user-ana = ./user/ana.nix;
      # container-postgres = import ./container/postgres.nix { inherit self; };
    };
  };
}
