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

    networking.hostName = "architect";
    networking.domain = "hoverbear.home";
  };
}

