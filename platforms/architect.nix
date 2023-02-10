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
    # "${modulesPath}/profiles/qemu-guest.nix"
  ];

  config = {
    boot.kernelParams = [ "amd_iommu=on" "iommu=pt" "iommu=1" "rd.driver.pre=vfio-pci" ];
    boot.initrd.kernelModules = [ "amdgpu" ];
    boot.kernelModules = [ "tap" "kvm-amd" "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];

    services.xserver.videoDrivers = [ "amdgpu" ];

    hardware.cpu.amd.updateMicrocode = true;

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
  
    virtualisation.docker.enable = true;

    nix.distributedBuilds = true;
    nix.settings.builders = [ "@/etc/nix/machines" ];

    networking.hostName = "architect";
    networking.domain = "hoverbear.home";
  };
}

