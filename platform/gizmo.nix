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
  boot.binfmt.emulatedSystems = [ "x86_64-linux" ];

  hardware.opengl.package =
    let
      myMesa = (pkgs.mesa.override {
        galliumDrivers = [ "radeonsi" "swrast" ];
      }).overrideAttrs (attrs: { patches = attrs.patches ++ [ ../patches/gizmo-lx2k-mesa.patch ]; });
    in
    lib.mkForce myMesa.drivers;

  networking.hostId = "05dc175e";
  networking.hostName = "gizmo";
  networking.domain = "hoverbear.dev";
  networking.interfaces.eth0.useDHCP = true;

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

  #nixpkgs.config.allowUnsupportedSystem = true;
}
