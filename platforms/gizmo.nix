{ config, pkgs, lib, modulesPath, ... }:

let
  devices = {
    encrypted = rec {
      uuid = "f74df5fc-7632-4e47-a481-9fd346cfad71";
      label = "gizmo";
    };
    boot = rec {
      uuid = "D41A-2BB7";
      label = "boot";
    };
  };
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  config = {
    boot.kernelParams = [
      # PCIE scaling tends to lock GPUs, jnettlet suggests...
      # "amdgpu.pcie_gen_cap=0x4"
      "radeon.si_support=0"
      "amdgpu.si_support=1"
      # https://discord.com/channels/620838168794497044/665456384971767818/913331830290284544
      "arm-smmu.disable_bypass=0"
      "iommu.passthrough=1"
      "amdgpu.pcie_gen_cap=0x4"
      "usbcore.autosuspend=-1"
      # Serial port
      #"console=ttyAMA0,115200"
      #"earlycon=pl011,mmio32,0x21c0000"
      #"pci=pcie_bus_perf"
      #"arm-smmu.disable_bypass=0" # TODO: remove once firmware supports it
    ];
    boot.kernelModules = [
      "amc6821" # via sensors-detect
    ];
    boot.initrd.luks.devices = {
      gizmo = {
        device = "/dev/disk/by-uuid/${devices.encrypted.uuid}";
      };
    };
    boot.initrd.kernelModules = [ "amdgpu" ];
    services.xserver.videoDrivers = [ "amdgpu" ];

    fileSystems."/" = {
      device = "/dev/mapper/${devices.encrypted.label}";
      fsType = "f2fs";
      encrypted.enable = true;
      encrypted.label = devices.encrypted.label;
      encrypted.blkDev = "/dev/disk/by-uuid/${devices.encrypted.uuid}";
      options = [
        "compress_algorithm=zstd"
        "atgc"
        "lazytime"
      ];
    };
    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/${devices.boot.uuid}";
      fsType = "vfat";
    };

    networking.hostName = "gizmo";
    networking.domain = "hoverbear.home";

    # Disable the GNOME3/GDM auto-suspend feature that cannot be disabled in GUI!
    # If no user is logged in, the machine will power down after 20 minutes.
    # This results in a `wall` style message which disrupts console users.
    systemd.targets.sleep.enable = false;
    systemd.targets.suspend.enable = false;
    systemd.targets.hibernate.enable = false;
    systemd.targets.hybrid-sleep.enable = false;
    services.xserver.displayManager.gdm.autoSuspend = false;

    # This works around some 'glitching' in many GTK applications (and, importantly, Firefox)
    # jnettlet suggested the following patch:
    /*hardware.opengl.package =
      let
      myMesa = (pkgs.mesa.override {
      galliumDrivers = [ "radeonsi" "swrast" ];
      }).overrideAttrs (attrs: { patches = attrs.patches ++ [ ../patches/gizmo-lx2k-mesa.patch ]; });
      in
      lib.mkForce myMesa.drivers;
    */

    /*
    nixpkgs.localSystem.system = "aarch64-linux";
    nixpkgs.localSystem.platform = (lib.systems.elaborate "aarch64-linux") // {
      sys.gcc = {
        fpu = "neon";
        cpu = "cortex-a72";
        arch = "armv8-a+crc+crypto";
      };
    };
    */

    nixpkgs.overlays = [
      (final: prev: {
        # The default flags used in Nix builds are rather suboptimal for the LX2K.
        # Additionally the `../trait/source-build.nix` trick won't work with Clang since it won't 
        # accept `-march=native` with the LX2K.
        /*
          stdenv = prev.stdenv // {
          mkDerivation = args: prev.stdenv.mkDerivation (args // {
          NIX_CFLAGS_COMPILE = toString (args.NIX_CFLAGS_COMPILE or "") + " -march=armv8-a+crc+crypto -ftree-vectorize";
          });
          };
        */
        # Because the above option changes the hash of stdnenv, and the current
        # `rustPlatform.buildRustPackage`'s build proces includes creating a SHA checked
        # `${name}-vendor` derivation, we must unfortunately opt out of the optimization
        # in the Rust platform.
        # inherit (prev) rustPlatform fetchCargoTarball cargo rustc rustup nix nixUnstable;
      })
    ];

    # nixpkgs.config.allowUnsupportedSystem = true;

    /* This seems to be a no-op??
      nixpkgs.system = lib.recursiveUpdate (lib.systems.elaborate { system = "aarch64-linux"; }) {
      system = "aarch64-linux";
      platform.gcc = {
      fpu = "neon";
      cpu = "cortex-a72";
      arch = "armv8-a+crc+crypto";
      tune = "armv8-a+crc+crypto";
      extraFlags = [ "-ftree-vectorize" ];
      };
      };
      */
  };
}
