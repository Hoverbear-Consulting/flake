/*
  Make a mount tree for adding to `fileSystems`

*/
{ encryptedDeviceLabel, encryptedDevice, efiDevice }:

{
  "/" = {
    device = "/dev/mapper/${encryptedDeviceLabel}";
    fsType = "btrfs";
    encrypted = {
      enable = true;
      label = encryptedDeviceLabel;
      blkDev = encryptedDevice;
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
      blkDev = encryptedDevice;
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
      blkDev = encryptedDevice;
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
      blkDev = encryptedDevice;
    };
    neededForBoot = true;
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
      blkDev = encryptedDevice;
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
      blkDev = encryptedDevice;
    };
    neededForBoot = true;
    options = [
      "subvol=log"
      "compress=zstd"
      "lazytime"
    ];
  };
  "/efi" = {
    device = efiDevice;
    fsType = "vfat";
  };
}
