/*
  A trait for headed boxxen
*/
{ config, pkgs, lib, ... }:

{
  config = {
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.displayManager.autoLogin.enable = false;
    services.xserver.desktopManager.gnome.enable = true;
    environment.gnome.excludePackages = (with pkgs; [
      gnome-photos
      gnome-tour
    ]) ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-music
      gedit # text editor
      epiphany # web browser
      geary # email reader
      gnome-characters
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
      yelp # Help view
      gnome-contacts
      gnome-initial-setup
    ]);


    # So gtk themes can be set
    programs.dconf.enable = true;
    services.dbus.packages = with pkgs; [ dconf ];

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
      virt-manager
      gnome.gnome-tweaks
      gnome.gnome-characters
    ] ++ (if stdenv.isx86_64 then [
      kicad
      chromium
      spotify
      obs-studio
    ] else if stdenv.isAarch64 then [
      spotifyd
    ] else [ ]);

    services.printing.enable = true;
  };
}

