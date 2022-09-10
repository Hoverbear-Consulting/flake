/*
  Make a mount tree for adding to `fileSystems`

*/
{ encryptedDeviceLabel, efiDeviceLabel }:

{
  "/" = {
    device = "/dev/mapper/${encryptedDeviceLabel}";
    fsType = "btrfs";
    encrypted = {
      enable = true;
      label = encryptedDeviceLabel;
      blkDev = "/dev/disk/by-label/${encryptedDeviceLabel}";
    };
    options = [
      "subvol=root"
      "compress=zstd"
      "lazytime"
    ];
  };
  "/home" = {
    device = "/dev/mapper/${encryptedDeviceLabel}";
    fsType = "btrfs";
    encrypted = {
      enable = true;
      label = encryptedDeviceLabel;
      blkDev = "/dev/disk/by-label/${encryptedDeviceLabel}";
    };
    options = [
      "subvol=home"
      "compress=zstd"
      "lazytime"
    ];
  };
  "/nix" = {
    device = "/dev/mapper/${encryptedDeviceLabel}";
    fsType = "btrfs";
    encrypted = {
      enable = true;
      label = encryptedDeviceLabel;
      blkDev = "/dev/disk/by-uuid/${encryptedDeviceLabel}";
    };
    options = [
      "subvol=nix"
      "compress=zstd"
      "lazytime"
    ];
  };
  "/persist" = {
    device = "/dev/mapper/${encryptedDeviceLabel}";
    fsType = "btrfs";
    encrypted = {
      enable = true;
      label = encryptedDeviceLabel;
      blkDev = "/dev/disk/by-label/${encryptedDeviceLabel}";
    };
    options = [
      "subvol=persist"
      "compress=zstd"
      "lazytime"
    ];
  };
  "/boot" = {
    device = "/dev/mapper/${encryptedDeviceLabel}";
    fsType = "btrfs";
    encrypted = {
      enable = true;
      label = encryptedDeviceLabel;
      blkDev = "/dev/disk/by-label/${encryptedDeviceLabel}";
    };
    neededForBoot = true;
    options = [
      "subvol=boot"
      "compress=zstd"
      "lazytime"
    ];
  };
  "/var/log" = {
    device = "/dev/mapper/${encryptedDeviceLabel}";
    fsType = "btrfs";
    encrypted = {
      enable = true;
      label = encryptedDeviceLabel;
      blkDev = "/dev/disk/by-label/${encryptedDeviceLabel}";
    };
    neededForBoot = true;
    options = [
      "subvol=log"
      "compress=zstd"
      "lazytime"
    ];
  };
  "/boot" = {
    device = "/dev/disk/by-label/${efiDeviceLabel}";
    fsType = "vfat";
  };
}
