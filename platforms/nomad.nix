{ config, pkgs, lib, modulesPath, ... }:

let
  encryptedDeviceLabel = "encrypt";
  encryptedDevice = "/dev/nvme0n1p2";
  efiDevice = "/dev/nvme0n1p1";
  makeMounts = import ./../functions/make_mounts.nix;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  config = {
    boot.kernelModules = [ "kvm-intel" ];
    boot.kernel.sysctl = {
      "dev.i915.perf_stream_paranoid" = 0;
    };
    fileSystems = makeMounts {
      inherit encryptedDevice encryptedDeviceLabel efiDevice;
    };

    networking.hostName = "nomad";
    networking.domain = "hoverbear.home";
  };
}

