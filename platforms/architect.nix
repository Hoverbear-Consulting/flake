{ config, pkgs, lib, modulesPath, ... }:

let
  devices = {
    encrypted = rec {
      uuid = "102d36f0-1c99-43d3-855b-e448a57ca4e3";
      label = "architect";
    };
    boot = rec {
      uuid = "9B3C-1A78";
      label = "boot";
    };
  };
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  config = {
    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.loader.grub.enable = true;
    boot.loader.grub.efiSupport = true;
    boot.loader.grub.useOSProber = true;
    boot.loader.grub.efiInstallAsRemovable = true;
    boot.loader.grub.device = "nodev";
    boot.loader.grub.configurationLimit = 10;
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
    boot.initrd.luks.devices = {
      architect = {
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

    networking.hostId = "938c2500";
    networking.hostName = "architect";
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
  };
}

