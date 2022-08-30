/*
A trait for headed boxxen
*/
{ config, pkgs, lib, ... }:

{
  config = {
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.displayManager.autoLogin.enable = true;
    services.xserver.displayManager.autoLogin.user = "ana";
    services.xserver.desktopManager.gnome.enable = true;

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

    # These should only be GUI applications that are desired systemwide
    environment.systemPackages = with pkgs; [
      firefox
      neovimConfigured
      zotero
      inkscape
      gimp
    ] ++ (if stdenv.isx86_64 then [
      kicad
      vscodeConfigured
      chromium
      spotify
      obs-studio
    ] else if stdenv.isaarch64 then [
      spotifyd
    ] else []);

    services.printing.enable = true;
  };
}

