{
  description = "Hoverbear's Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    lx2k-nix.url = "github:hoverbear-consulting/lx2k-nix/flake";
    lx2k-nix.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.url = "github:hoverbear-consulting/NixOS-WSL/modularize";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, lx2k-nix, nixos-wsl }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in
    {
      overlay = final: prev: {
        neovimConfigured = final.callPackage ./packages/neovim.nix { };
        vscodeConfigured = final.callPackage ./packages/vscode.nix { };
      };

      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlay ];
            config.allowUnfree = true;
          };
        in
        {
          inherit (pkgs) neovimConfigured vscodeConfigured;
        });

      nixosConfigurations =
        let
          gizmoBase = {
            system = "aarch64-linux";
            modules = with self.nixosModules; [
              lx2k-nix.nixosModules.lx2k
              trait.overlay
              trait.base
              trait.hardened
              trait.machine
              trait.tools
              user.ana
            ];
          };
          architectBase = {
            system = "x86_64-linux";
            modules = with self.nixosModules; [
              trait.overlay
              trait.base
              trait.hardened
              trait.machine
              trait.tools
              trait.jetbrains
              user.ana
              # plrust.nixosModule
              # ({pkgs, ...}: { 
              #   services.postgresql.enable = true;
              #   services.postgresql.plrust.enable = true;
              #   services.postgresql.plrust.workDir = "/tmp/plrust";
              # })
            ];
          };
        in
        with self.nixosModules; {
          gizmo = nixpkgs.lib.nixosSystem {
            inherit (gizmoBase) system;
            modules = gizmoBase.modules ++ [
              platform.gizmo
              trait.workstation
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
              trait.overlay
              trait.base
              trait.tools
              trait.jetbrains
              nixos-wsl.nixosModule
              platform.wsl
            ];
          };
        };

      nixosModules = {
        platform.container = ./platform/container.nix;
        platform.wsl = ./platform/wsl.nix;
        platform.gizmo = ./platform/gizmo.nix;
        platform.architect = ./platform/architect.nix;
        platform.iso-minimal = "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix";
        platform.iso = "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-plasma5.nix";
        trait.overlay = { nixpkgs.overlays = [ self.overlay ]; };
        trait.base = ./trait/base.nix;
        trait.machine = ./trait/machine.nix;
        trait.tools = ./trait/tools.nix;
        trait.jetbrains = ./trait/jetbrains.nix;
        trait.hardened = ./trait/hardened.nix;
        trait.sourceBuild = ./trait/source-build.nix;
        service.postgres = ./service/postgres.nix;
        # This trait is unfriendly to being bundled with platform-iso
        trait.workstation = ./trait/workstation.nix;
        user.ana = ./user/ana.nix;
      };

      checks = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlay ];
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

      devShell = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlay ];
          };
        in
        pkgs.mkShell {
          inputsFrom = with pkgs; [ ];
          buildInputs = with pkgs; [
            nixpkgs-fmt
          ];
        });
    };
}
