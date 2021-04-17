{ config, pkgs, lib, ... }:

{
  # Enable the GNOME 3 Desktop Environment.
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # For Network Manager
  networking.wireless.enable = false;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.steam-hardware.enable = true;
  hardware.xpadneo.enable = true;

  fonts.fontconfig.enable = true;
  fonts.enableDefaultFonts = true;
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    jetbrains-mono
    fira-code
    fira-code-symbols
  ];

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    firefox
    jetbrains.clion
    jetbrains.datagrip
    slack
    discord
    zoom-us
    spotify
    zotero
    vscode
    slack
    gnome3.gnome-tweaks
    kicad
    inkscape
    freecad
  ];

  services.printing.enable = true;

}

