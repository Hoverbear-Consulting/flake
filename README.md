# Nix Flake of Hoverbear Consulting

This is a flake containing expressions made by [Hoverbear Consulting][hoverbear-consulting].

You can use this in your own flakes:

```nix
# flake.nix
{
  inputs.hoverbear.url = "github:hoverbear-consulting/flake";
  outputs = { self, hoverbear-consulting, ... }: { /* ... */ };
}
```

# Packages

* `neovimConfigured`: A configured `nvim` with plugins.
* `vscodeConfigured`: A `vscode` with extensions.

# NixOS Configurations

General dogma:

* Only UEFI, with a 512MB+ FAT32 partition on the `/boot` block device.
* F2FS based root block devices (in a `dm-crypt`).
* Firewalled except port 22.
* Preconfigured, ready to use, global (`nvim`) editor and shell (`sh`) configuration.
* Somewhat hardened hardware nodes.
* Relaxed user access control.
* `nix-direnv`/`envrc` support for `use nix`/`use flake`.
* Nix features `nix-command` and `flake` adopted.

## Architect

An x86_64 workstation & gaming rig.

* [32 core Ryzen 9][chips-amd3950x] in an [X570][parts-gigabyte-x5700-xt]
* [4x 16 GB, 3200 Mhz RAM][parts-corsair-vengance-32gb-3200mgz-ddr4-dimm]
* [375 GB PCI-E Optane P4800X][parts-intel-optane-P4800X] (`pool`)
* [1 TB M.2 NVMe][parts-samsung-970-pro-1tb-m2] (A dedicated, untouched Windows Disk)
* [AMD x5700 XT][parts-gigabyte-x5700-xt]

## Preparation

Requires:

* An `x86_64-linux` based `nix`.
* A USB stick, 8+ GB preferred. ([Ex][parts-usb-stick-ex])

Build a recovery image:

```bash
nix build github:hoverbear-consulting/flake#nixosConfigurations.architectIsoImage.config.system.build.isoImage --out-link isoImage
```

Flash it to a USB:

```bash
ARCHITECT_USB=/dev/null
umount $ARCHITECT_USB
sudo cp -vi isoImage/iso/*.iso $ARCHITECT_USB
```

## Bootstrap


Start the machine, or reboot it. Once logged in, partion, format, and mount the NVMe disk:

```bash
umount /dev/nvme1n1
sgdisk -Z /dev/nvme1n1
sgdisk -o /dev/nvme1n1
partprobe

sgdisk /dev/nvme1n1 -n 1:0:+512M
sgdisk /dev/nvme1n1 -t 1:ef00
sgdisk /dev/nvme1n1 -c 1:EFI /dev/nvme1n1

sgdisk /dev/nvme1n1 -n 2:0:0 /dev/nvme1n1
sgdisk /dev/nvme1n1 -t 2:8300 /dev/nvme1n1
sgdisk /dev/nvme1n1 -c 2:pool /dev/nvme1n1

export BOOT_DEVICE=/dev/nvme1n1p1
export ROOT_DEVICE=/dev/nvme1n1p2
export CRYPT_NAME=architect

cryptsetup luksFormat --type luks1 ${ROOT_DEVICE}
cryptsetup open ${ROOT_DEVICE} ${CRYPT_NAME}

mkfs.f2fs -l root -O extra_attr,inode_checksum,sb_checksum,compression,encrypt /dev/mapper/${CRYPT_NAME} -f
mount -o compress_algorithm=zstd,whint_mode=fs-based,atgc,lazytime /dev/mapper/${CRYPT_NAME} /mnt/ -v

mkfs.vfat -F 32 ${BOOT_DEVICE}
mkdir -p /mnt/boot
mount ${BOOT_DEVICE} /mnt/boot
```

Bootstrap the persistence directories:

```bash
mkdir -p /mnt/persist/ssh
mkdir -p /mnt/persist/etc
```

Install the system:

```bash
nixos-install --flake github:hoverbear-consulting/flake#architect --impure
```

Finally, copy over the shadow before rebooting:

```bash
cp /etc/shadow /mnt/persist/etc/shadow
```

## Gizmo

Gizmo, a headless aarch64 server.

* [SolidRun HoneyComb LX2K][parts-lx2k]
  + [16 core Cortex A72][chips-arm-cortex-a72]
* [2x 32 GB, 3200 Mhz RAM][parts-hyperx-impact-32gb-3200mhz-ddr4-sodimm]
* [1 TB M.2 NVMe][parts-samsung-970-evo-plus-1tb-m2] (`pool`)

### Preparation

Requires:

* An `aarch64-linux` system or a `x86_64-linux` install of `nixos` with:
  
  ```nix
  # /etc/nixos/configuration.nix
  {
    # If not on an aarch64-linux
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
    # Default in NixOS stock kernel.
    boot.kernelModules = [
      "ftdi_sio"
    ];
  }
  ```
* A microUSB to USB cable. ([Ex][parts-microusb-to-usb-cable-ex])
* A microSD card. ([Ex][parts-microsd-card-ex])
* A USB stick, 4+ GB preferred. ([Ex][parts-usb-stick-ex])

Build the recovery image:

```bash
nix build github:hoverbear-consulting/flake#nixosConfigurations.gizmoIsoImage.config.system.build.isoImage --out-link isoImage
```

Fetch the SolidRun provided UEFI:

```bash
curl https://solid-run-images.sos-de-fra-1.exo.io/LX2k/lx2160a_uefi/lx2160acex7_2000_700_3200_8_5_2_sd_ee5c233.img.xz -o uefi.img.xz
xz --decompress uefi.img.xz
```


Flash them:

```bash
GIZMO_SD=/dev/null
GIZMO_USB=/dev/null
umount $GIZMO_SD
sudo cp -vi uefi.img $GIZMO_SD
umount $GIZMO_USB
sudo cp -vi isoImage/iso/*.iso $GIZMO_USB
```

### Bootstrap

Plug in the USB stick and SD card, then stick the microUSB into the CONSOLE port, and start a serial connection on the other machine:

```bash
sudo nix run nixpkgs#picocom -- /dev/ttyUSB0 -b 115200
```

Start the machine, or reboot it. Once logged in, partion, format, and mount the NVMe disk:

```bash
sgdisk -Z /dev/nvme0n1
sgdisk -o /dev/nvme0n1
partprobe

sgdisk /dev/nvme0n1 -n 1:0:+512M
sgdisk /dev/nvme0n1 -t 1:ef00
sgdisk /dev/nvme0n1 -c 1:EFI /dev/nvme0n1

sgdisk /dev/nvme0n1 -n 2:0:0 /dev/nvme0n1
sgdisk /dev/nvme0n1 -t 2:8300 /dev/nvme0n1
sgdisk /dev/nvme0n1 -c 2:gizmo /dev/nvme0n1

export BOOT_DEVICE=/dev/nvme0n1p1
export ROOT_DEVICE=/dev/nvme0n1p2
export CRYPT_NAME=gizmo

cryptsetup luksFormat --type luks1 ${ROOT_DEVICE}
cryptsetup open ${ROOT_DEVICE} ${CRYPT_NAME}

mkfs.f2fs -l root -O extra_attr,inode_checksum,sb_checksum,compression,encrypt /dev/mapper/${CRYPT_NAME} -f
mount -o compress_algorithm=zstd,whint_mode=fs-based,atgc,lazytime /dev/mapper/${CRYPT_NAME} /mnt/ -v

mkfs.vfat -F 32 ${BOOT_DEVICE}
mkdir -p /mnt/boot
mount ${BOOT_DEVICE} /mnt/boot
```


Install the system:

```bash
nixos-install --flake github:hoverbear-consulting/flake#gizmo --impure
```

## WSL

A system for on Windows (WSL2).

### Preparation

Build the tarball:

```bash
nix build github:hoverbear-consulting/flake#nixosConfigurations.wsl.system.build.tarball --out-link tarBall
```

Ensure the Windows install has WSL(2) enabled:

```powershell
Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux"
Enable-WindowsOptionalFeature -Online -FeatureName "VirtualMachinePlatform" 
wsl --set-default-version 2
```

### Bootstrap

Import the tarball:


```powershell
wsl --import nixos .\nixos\ tarBall/tarball/nixos-system-x86_64-linux.tar.gz --version 2
wsl --set-default nixos
```

Then, inside the WSL container:

```bash
/nix/var/nix/profiles/system/activate
```

Ctrl+D to log out, then re-enter with `wsl -d nixos`. This should result in a working user shell.


[hoverbear-consulting]: https://hoverbear.org
[chips-amd3950x]: https://en.wikichip.org/wiki/amd/ryzen_9/3950x
[chips-arm-cortex-a72]: https://en.wikichip.org/wiki/arm_holdings/microarchitectures/cortex-a72
[parts-microusb-to-usb-cable-ex]: https://www.memoryexpress.com/Products/MX30019
[parts-microsd-card-ex]: https://shop.solid-run.com/product/MSD016B/
[parts-usb-stick-ex]: https://www.memoryexpress.com/Products/MX64592
[parts-lx2k]: https://shop.solid-run.com/product/SRLX216S00D00GE064H08CH/
[parts-hyperx-impact-32gb-3200mhz-ddr4-sodimm]: https://www.memoryexpress.com/Products/MX80507
[parts-samsung-970-evo-plus-1tb-m2]: https://www.memoryexpress.com/Products/MX76118
[parts-samsung-970-pro-1tb-m2]: https://www.memoryexpress.com/Products/MX72359
[parts-x570-aorus-pro-wifi]: https://www.memoryexpress.com/Products/MX77641
[parts-gigabyte-x5700-xt]: https://www.gigabyte.com/ca/Graphics-Card/GV-R57XTGAMING-OC-8GD-rev-10#kf
[parts-corsair-vengance-32gb-3200mgz-ddr4-dimm]: https://www.memoryexpress.com/Products/MX00115415
[parts-intel-optane-P4800X]: https://www.intel.com/content/www/us/en/products/memory-storage/solid-state-drives/data-center-ssds/optane-dc-ssd-series/optane-dc-p4800x-series/p4800x-375gb-aic-20nm.html
[references-erase-your-darlings]: https://grahamc.com/blog/erase-your-darlings
