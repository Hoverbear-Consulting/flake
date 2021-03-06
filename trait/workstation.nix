{ config, pkgs, lib, ... }:

{
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "ana";
  services.xserver.desktopManager.plasma5.enable = true;
  # services.xserver.desktopManager.xfce.thunarPlugins = with pkgs; [
  #   xfce.thunar-archive-plugin
  # ];

  services.xserver.videoDrivers = [ "amdgpu" ];
  networking.wireless.enable = false; # For Network Manager

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  hardware.opengl.driSupport = true;
  #hardware.steam-hardware.enable = true;
  #hardware.xpadneo.enable = true;

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

  systemd.services.spotifyd.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    firefox
    chromium
    vscodeConfigured
    neovimConfigured
    spotifyd
    zotero
    kicad
    inkscape
    gimp
    xlockmore
  ] ++ (if stdenv.isx86_64 then [
    zoom-us
    spotify
    obs-studio
  ] else [ ]);

  services.printing.enable = true;
}

