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
    architect = {
      device = "/dev/disk/by-uuid/9a3c5794-2edf-430a-9a21-177da3fddcc2";
    };
  };
  boot.initrd.kernelModules = [ "amdgpu" ];

  fileSystems."/" = {
    device = "/dev/mapper/architect";
    fsType = "f2fs";
    encrypted.enable = true;
    encrypted.label = "architect";
    encrypted.blkDev = "/dev/disk/by-uuid/9a3c5794-2edf-430a-9a21-177da3fddcc2";
    options = [
      "compress_algorithm=zstd"
      "whint_mode=fs-based"
      "atgc"
      "lazytime"
    ];
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/4FD4-E75A";
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

  hardware.bluetooth.enable = true;

  swapDevices = [ ];
}

