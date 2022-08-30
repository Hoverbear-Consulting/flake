{ config, pkgs, lib, ... }:

{
  config = {
    environment.systemPackages = with pkgs; [
      jetbrains.clion
      jetbrains.datagrip
    ];

    # CLion requires cargo-xlib.
    environment.noXlibs = lib.mkForce false;

    nixpkgs.config.allowUnfree = true;
  };
}
