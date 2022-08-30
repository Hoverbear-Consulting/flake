{ config, pkgs, lib, modulesPath, ... }:

let
  encryptedDeviceUuid = "042de80f-f3ec-4e01-8c10-9b43436d301d";
  efiDeviceUuid = "9805-1C26";
  makeMounts = import ./../functions/make_mounts.nix;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  config = {
    services.xserver.displayManager.autoLogin.user = "ana";
    boot.kernel.sysctl = {
      "dev.i915.perf_stream_paranoid" = 0;
    };
    boot.loader.efi.efiSysMountPoint = "/boot/efi";
    boot.initrd.luks.devices = {
      encrypt = {
        device = "/dev/disk/by-uuid/${encryptedDeviceUuid}";
        keyFile = "/keyfile.bin";
        allowDiscards = true;
      };
    };
    boot.initrd.secrets = {
      "keyfile.bin" = "/etc/secrets/initrd/keyfile.bin";
    };

    fileSystems = makeMounts {
      inherit encryptedDeviceUuid efiDeviceUuid;
      keyFile = "/keyfile.bin";
    };

    networking.hostName = "nomad";
    networking.domain = "hoverbear.home";
  };
}

