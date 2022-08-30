/*
Make a mount tree for adding to `fileSystems`, eg:

```nix
{
  fileSystems = (import make_mounts.nix) {
    encryptedDeviceUuid: "boop";
    efiDeviceUuid: "swoop";
    keyFile: "/beep";
  };
}
```

*/
{ encryptedDeviceUuid, efiDeviceUuid, keyFile }:

let 
  encryptLabel = "encrypt";
in {
  "/" = {
    device = "/dev/mapper/${encryptLabel}";
    fsType = "btrfs";
    encrypted = {
      enable = true;
      label = encryptLabel;
      blkDev = "/dev/disk/by-uuid/${encryptedDeviceUuid}";
      keyFile = keyFile;
    };
    options = [
      "subvol=root"
      "compress=zstd"
      "lazytime"
    ];
  };
  "/home" = {
    device = "/dev/mapper/${encryptLabel}";
    fsType = "btrfs";
    encrypted = {
      enable = true;
      label = encryptLabel;
      blkDev = "/dev/disk/by-uuid/${encryptedDeviceUuid}";
      keyFile = keyFile;
    };
    options = [
      "subvol=home"
      "compress=zstd"
      "lazytime"
    ];
  };
  "/nix" = {
    device = "/dev/mapper/${encryptLabel}";
    fsType = "btrfs";
    encrypted = {
      enable = true;
      label = encryptLabel;
      blkDev = "/dev/disk/by-uuid/${encryptedDeviceUuid}";
      keyFile = keyFile;
    };
    options = [
      "subvol=nix"
      "compress=zstd"
      "lazytime"
    ];
  };
  "/persist" = {
    device = "/dev/mapper/${encryptLabel}";
    fsType = "btrfs";
    encrypted = {
      enable = true;
      label = encryptLabel;
      blkDev = "/dev/disk/by-uuid/${encryptedDeviceUuid}";
      keyFile = keyFile;
    };
    options = [
      "subvol=persist"
      "compress=zstd"
      "lazytime"
    ];
  };
  "/boot" = {
    device = "/dev/mapper/${encryptLabel}";
    fsType = "btrfs";
    encrypted = {
      enable = true;
      label = encryptLabel;
      blkDev = "/dev/disk/by-uuid/${encryptedDeviceUuid}";
      keyFile = keyFile;
    };
    neededForBoot = true;
    options = [
      "subvol=boot"
      "compress=zstd"
      "lazytime"
    ];
  };
  "/var/log" = {
    device = "/dev/mapper/${encryptLabel}";
    fsType = "btrfs";
    encrypted = {
      enable = true;
      label = encryptLabel;
      blkDev = "/dev/disk/by-uuid/${encryptedDeviceUuid}";
      keyFile = keyFile;
    };
    neededForBoot = true;
    options = [
      "subvol=log"
      "compress=zstd"
      "lazytime"
    ];
  };
  "/boot/efi" = {
    device = "/dev/disk/by-uuid/${efiDeviceUuid}";
    fsType = "vfat";
  };
}
