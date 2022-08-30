{ config, pkgs, lib, modulesPath, ... }:

let
  devices = {
    encrypted = {
      uuid = "042de80f-f3ec-4e01-8c10-9b43436d301d";
      label = "encrypt";
    };
    efi = {
      uuid = "9805-1C26";
    };
  };
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  config = {
    boot.loader.efi.efiSysMountPoint = "/boot/efi";
    boot.initrd.luks.devices = {
      encrypt = {
        device = "/dev/disk/by-uuid/${devices.encrypted.uuid}";
        keyFile = "/keyfile.bin";
        allowDiscards = true;
      };
    };
    boot.initrd.secrets = {
      "keyfile.bin" = "/etc/secrets/initrd/keyfile.bin";
    };

    fileSystems."/" = {
      device = "/dev/mapper/${devices.encrypted.label}";
      fsType = "btrfs";
      encrypted = {
        enable = true;
        label = devices.encrypted.label;
        blkDev = "/dev/disk/by-uuid/${devices.encrypted.uuid}";
        keyFile = "/keyfile.bin";
      };
      options = [
        "subvol=root"
        "compress=zstd"
        "lazytime"
      ];
    };
    fileSystems."/home" = {
      device = "/dev/mapper/${devices.encrypted.label}";
      fsType = "btrfs";
      encrypted = {
        enable = true;
        label = devices.encrypted.label;
        blkDev = "/dev/disk/by-uuid/${devices.encrypted.uuid}";
        keyFile = "/keyfile.bin";
      };
      options = [
        "subvol=home"
        "compress=zstd"
        "lazytime"
      ];
    };
    fileSystems."/nix" = {
      device = "/dev/mapper/${devices.encrypted.label}";
      fsType = "btrfs";
      encrypted = {
        enable = true;
        label = devices.encrypted.label;
        blkDev = "/dev/disk/by-uuid/${devices.encrypted.uuid}";
        keyFile = "/keyfile.bin";
      };
      options = [
        "subvol=nix"
        "compress=zstd"
        "lazytime"
      ];
    };
    fileSystems."/persist" = {
      device = "/dev/mapper/${devices.encrypted.label}";
      fsType = "btrfs";
      encrypted = {
        enable = true;
        label = devices.encrypted.label;
        blkDev = "/dev/disk/by-uuid/${devices.encrypted.uuid}";
        keyFile = "/keyfile.bin";
      };
      options = [
        "subvol=persist"
        "compress=zstd"
        "lazytime"
      ];
    };
    fileSystems."/boot" = {
      device = "/dev/mapper/${devices.encrypted.label}";
      fsType = "btrfs";
      encrypted = {
        enable = true;
        label = devices.encrypted.label;
        blkDev = "/dev/disk/by-uuid/${devices.encrypted.uuid}";
        keyFile = "/keyfile.bin";
      };
      neededForBoot = true;
      options = [
        "subvol=boot"
        "compress=zstd"
        "lazytime"
      ];
    };
    fileSystems."/var/log" = {
      device = "/dev/mapper/${devices.encrypted.label}";
      fsType = "btrfs";
      encrypted = {
        enable = true;
        label = devices.encrypted.label;
        blkDev = "/dev/disk/by-uuid/${devices.encrypted.uuid}";
        keyFile = "/keyfile.bin";
      };
      neededForBoot = true;
      options = [
        "subvol=log"
        "compress=zstd"
        "lazytime"
      ];
    };
    fileSystems."/boot/efi" = {
      device = "/dev/disk/by-uuid/${devices.efi.uuid}";
      fsType = "vfat";
    };

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

    networking.hostName = "nomad";
    networking.domain = "hoverbear.home";
  };
}

