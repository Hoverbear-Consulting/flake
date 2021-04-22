/*
  Machine specific settings for Gizmo.
*/
{ config, pkgs, lib, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.zfsSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev";
  boot.supportedFilesystems = [ "zfs" ];
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r pool/scratch@blank
  '';
  boot.binfmt.emulatedSystems = [ "x86_64-linux" ];

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

  networking.hostId = "05dc175e";
  networking.hostName = "gizmo";
  networking.domain = "hoverbear.dev";
  networking.interfaces.eth0.useDHCP = true;

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

  nixpkgs.config.allowUnsupportedSystem = true;
}
