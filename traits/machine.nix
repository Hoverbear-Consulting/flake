{ pkgs, ... }:

{
  config = {
    boot.kernel.sysctl = {
      # TCP Fast Open (TFO)
      "net.ipv4.tcp_fastopen" = 3;
    };
    boot.initrd.availableKernelModules = [
      "usb_storage"
      "nbd"
      "nvme"
    ];
    boot.kernelModules = [
      "coretemp"
    ];
    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.loader.grub.enable = true;
    boot.loader.grub.efiSupport = true;
    boot.loader.grub.useOSProber = true;
    boot.loader.grub.efiInstallAsRemovable = true;
    boot.loader.grub.device = "nodev";
    boot.loader.grub.version = 2;
    boot.loader.grub.configurationLimit = 10;
    boot.loader.grub.enableCryptodisk = true;
    boot.binfmt.emulatedSystems = (if pkgs.stdenv.isx86_64 then [
      "aarch64-linux"
    ] else if pkgs.stdenv.is_aarch64 then [
      # "x86_64-linux"
    ] else []);

    powerManagement.cpuFreqGovernor = "ondemand";
    
    networking.networkmanager.enable = true;
    networking.wireless.enable = false; # For Network Manager
    programs.nm-applet.enable = true;
    hardware.bluetooth.enable = true;

    sound.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    security.rtkit.enable = true;
    hardware.pulseaudio.enable = false;

    swapDevices = [ ];
  };
}
