{ config, pkgs, lib, modulesPath, ... }:

let
  encryptedDeviceLabel = "encrypt";
  encryptedDevice = "/dev/nvme1n1p2";
  efiDevice = "/dev/nvme1n1p1";
  makeMounts = import ./../functions/make_mounts.nix;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  config = {
    boot.initrd.kernelModules = [ "amdgpu" ];
    services.xserver.videoDrivers = [ "amdgpu" ];

    fileSystems = makeMounts {
      inherit encryptedDevice encryptedDeviceLabel efiDevice;
    };

    # This doesn't seem to work...
    /* environment.etc."crypttab" = {
      enable = true;
      text = ''
      encrypt /dev/nvme1n1p2 - fido2-device=auto
      '';
    }; */

    networking.hostName = "architect";
    networking.domain = "hoverbear.home";
  };
}

