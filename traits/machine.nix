/*
  A trait for configurations which are most definitely machines
*/
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
    ] else [ ]);

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

    # opt in state
    # From https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html
    environment.etc = {
      nixos.source = "/persist/etc/nixos";
      "NetworkManager/system-connections".source = "/persist/etc/NetworkManager/system-connections";
      adjtime.source = "/persist/etc/adjtime";
      # NIXOS.source = "/persist/etc/NIXOS";
      machine-id.source = "/persist/etc/machine-id";
      shadow.source = "/persist/etc/shadow";
    };
    systemd.tmpfiles.rules = [
      "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
      "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
      "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
      "L /etc/secrets - - - - /persist/secrets"
      #"L /var/lib/bluetooth - - - - /persist/var/lib/bluetooth"
    ];
    boot.initrd.postDeviceCommands = pkgs.lib.mkBefore ''
      mkdir -p /mnt

      # We first mount the btrfs root to /mnt
      # so we can manipulate btrfs subvolumes.
      mount -o subvol=/ /dev/mapper/encrypt /mnt

      # While we're tempted to just delete /root and create
      # a new snapshot from /root-blank, /root is already
      # populated at this point with a number of subvolumes,
      # which makes `btrfs subvolume delete` fail.
      # So, we remove them first.
      #
      # /root contains subvolumes:
      # - /root/var/lib/portables
      # - /root/var/lib/machines
      #
      # I suspect these are related to systemd-nspawn, but
      # since I don't use it I'm not 100% sure.
      # Anyhow, deleting these subvolumes hasn't resulted
      # in any issues so far, except for fairly
      # benign-looking errors from systemd-tmpfiles.

      btrfs subvolume list -o /mnt/root |
      cut -f9 -d' ' |
      while read subvolume; do
        echo "deleting /$subvolume subvolume..."
        btrfs subvolume delete "/mnt/$subvolume"
      done &&
      echo "deleting /root subvolume..." &&
      btrfs subvolume delete /mnt/root

      echo "restoring blank /root subvolume..."
      btrfs subvolume snapshot /mnt/snapshots/root/blank /mnt/root

      # Once we're done rolling back to a blank snapshot,
      # we can unmount /mnt and continue on the boot process.
      umount /mnt
    '';
    swapDevices = [ ];
  };
}
