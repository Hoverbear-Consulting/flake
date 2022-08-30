{ config, pkgs, lib, modulesPath, ... }:

let
  grub_device = "nvme-SAMSUNG_MZVLW512HMJP-000H1_S36ENB0JC10667";
  devices = {
    encrypted = {
      uuid = "4421ebea-f08f-449c-a2bc-e0e8369da94d";
      label = "encrypt";
    };
    efi = {
      uuid = "3F32-087A";
      label = "efi";
    };
  };
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "/dev/disk/by_id/${grub_device}";
  boot.loader.grub.configurationLimit = 10;
  boot.loader.grub.enableCryptodisk = true;
  boot.loader.efi.efiSysMountPoint = "/EFI";
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.initrd.luks.devices = {
    nomad = {
      device = "/dev/disk/by-uuid/${devices.encrypted.uuid}";
    };
  };

  fileSystems."/" = {
    device = "/dev/mapper/${devices.encrypted.label}";
    fsType = "btrfs";
    encrypted.enable = true;
    encrypted.label = devices.encrypted.label;
    encrypted.blkDev = "/dev/disk/by-uuid/${devices.encrypted.uuid}";
    options = [
      "compress=zstd"
      "lazytime"
    ];
  };
  fileSystems."/EFI" = {
    device = "/dev/disk/by-uuid/${devices.efi.uuid}";
    fsType = "vfat";
  };

  #networking.hostId = "938c2500";
  networking.hostName = "nomad";
  networking.domain = "hoverbear.home";
  #networking.interfaces.enp6s0.useDHCP = true;
  #networking.interfaces.wlp5s0.useDHCP = true;

  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;

  time.timeZone = "America/Vancouver";
  # Windows wants hardware clock in local time instead of UTC
  time.hardwareClockInLocalTime = true;

  hardware.bluetooth.enable = true;

  swapDevices = [ ];
}

