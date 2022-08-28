{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev";
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.initrd.luks.devices = {
    nomad = {
      device = "/dev/disk/by-uuid/aece3690-cfbb-480e-8598-1074074563d2";
    };
  };

  fileSystems."/" = {
    device = "/dev/mapper/nomad";
    fsType = "btrfs";
    encrypted.enable = true;
    encrypted.label = "nomad";
    encrypted.blkDev = "/dev/disk/by-uuid/aece3690-cfbb-480e-8598-1074074563d2";
    options = [
      "compress=zstd"
      "lazytime"
    ];
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0059-6D54";
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

