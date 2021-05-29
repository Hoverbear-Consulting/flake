/*
  Machine specific settings for Gizmo.
*/
{ config, pkgs, lib, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.kernelParams = [
    # PCIE scaling tends to lock GPUs, jnettlet suggests...
    "amdgpu.pcie_gen_cap=0x4"
    "radeon.si_support=0"
    "amdgpu.si_support=1"
  ];
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.zfsSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev";
  boot.supportedFilesystems = [ "zfs" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r pool/scratch@blank
  '';

  # boot.binfmt.emulatedSystems = [ "x86_64-linux" ];

  networking.hostId = "05dc175e";
  networking.hostName = "gizmo";
  networking.domain = "hoverbear.dev";
  networking.interfaces.eth0.useDHCP = true;

  hardware.bluetooth.enable = true;

  time.timeZone = "America/Vancouver";

  services.openssh.hostKeys = [
    {
      path = "/persist/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }
    {
      path = "/persist/ssh/ssh_host_rsa_key";
      type = "rsa";
      bits = 4096;
    }
  ];

  services.postgresql.dataDir = "/persist/postgresql";

  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;

  systemd.tmpfiles.rules = [
    "L+ /etc/shadow - - - - /persist/etc/shadow"
  ];

  fileSystems."/boot" = {
    device = "/dev/nvme0n1p1";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "pool/scratch";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "pool/nix";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "pool/home";
    fsType = "zfs";
  };

  fileSystems."/persist" = {
    device = "pool/persist";
    fsType = "zfs";
  };

  swapDevices = [ ];


  # This works around some 'glitching' in many GTK applications (and, importantly, Firefox)
  # jnettlet suggested the following patch:
  hardware.opengl.package =
    let
      myMesa = (pkgs.mesa.override {
        galliumDrivers = [ "radeonsi" "swrast" ];
      }).overrideAttrs (attrs: { patches = attrs.patches ++ [ ../patches/gizmo-lx2k-mesa.patch ]; });
    in
    lib.mkForce myMesa.drivers;

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
}
