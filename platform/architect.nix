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
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r pool/scratch@blank
  '';

  time.timeZone = "America/Vancouver";

  networking.hostId = "938c2500";
  networking.hostName = "architect";
  networking.domain = "hoverbear.dev";
  networking.interfaces.enp6s0.useDHCP = true;
  networking.interfaces.wlp5s0.useDHCP = true;
  
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

  systemd.tmpfiles.rules = [
    "L+ /etc/shadow - - - - /persist/etc/shadow"
  ];

  fileSystems."/boot" = {
    device = "/dev/nvme1n1p1";
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
}

