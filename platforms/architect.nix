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
    hardware.opengl.extraPackages = with pkgs; [
      rocm-opencl-icd
      rocm-runtime
    ];

    fileSystems = makeMounts {
      inherit encryptedDevice encryptedDeviceLabel efiDevice;
    };

    networking.hostName = "architect";
    networking.domain = "hoverbear.home";
  };
}

