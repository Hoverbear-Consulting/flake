{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    jetbrains.clion
    jetbrains.datagrip
  ];
  
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

  # CLion requires cargo-xlib.
  environment.noXlibs = lib.mkForce false;
  
  nixpkgs.config.allowUnfree = true;
}
