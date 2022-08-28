{ config, pkgs, lib, modulesPath, ... }:

let
  devices = {
    encrypted = rec {
      uuid = "aece3690-cfbb-480e-8598-1074074563d2";
      path = "/dev/disk/by-uuid/${uuid}";
      label = "nomad";
    };
    boot = rec {
      uuid = "0059-6D54";
      path = "/dev/disk/by-uuid/${uuid}";
      label = "boot";
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
  boot.loader.grub.device = "nodev";
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.initrd.luks.devices = {
    nomad = {
      device = devices.encrypted.path;
    };
  };

  fileSystems."/" = {
    device = "/dev/mapper/${devices.encrypted.label}";
    fsType = "btrfs";
    encrypted.enable = true;
    encrypted.label = devices.encrypted.label;
    encrypted.blkDev = devices.encrypted.path;
    options = [
      "compress=zstd"
      "lazytime"
    ];
  };
  fileSystems."/boot" = {
    device = devices.boot.path;
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

