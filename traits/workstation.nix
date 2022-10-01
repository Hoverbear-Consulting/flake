/*
  A trait for headed boxxen
*/
{ config, pkgs, lib, ... }:

{
  config = {
    hardware.video.hidpi.enable = true;
    hardware.opengl.enable = true;
    hardware.opengl.driSupport = true;
    hardware.opengl.extraPackages = with pkgs; [ libvdpau vdpauinfo libvdpau-va-gl ];

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

    # These should only be GUI applications that are desired systemwide
    environment.variables = {
      VDPAU_DRIVER = "radeonsi";
    };
    environment.systemPackages = with pkgs; [
      firefox
      neovimConfigured
      zotero
      inkscape
      gimp
      virt-manager
      gnome.gnome-tweaks
      gnome.gnome-characters
      openrgb
      libva-utils
      vdpauinfo
      ffmpeg
      openrgb
    ] ++ (if stdenv.isx86_64 then [
      kicad
      chromium
      spotify
      obs-studio
      obs-studio-plugins.obs-gstreamer
      obs-studio-plugins.obs-vkcapture
      obs-studio-plugins.obs-pipewire-audio-capture
      obs-studio-plugins.obs-multi-rtmp
      obs-studio-plugins.obs-move-transition
    ] else if stdenv.isAarch64 then [
      spotifyd
    ] else [ ]);

    services.udev.packages = with pkgs; [ openrgb ];
    services.printing.enable = true;
  };
}

