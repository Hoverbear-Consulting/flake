/*
  A trait for boxxen which game

  Includes both gaming related packages as well as bleeding edge wine.

  ## Important note

  After install you should run:

  ```bash
  winetricks corefonts
  winetricks vcrun2005sp1
  winetricks d3dx9
  winetricks d3dx10
  winetricks dxvk

  winecfg
  ```

  In `winecfg` under "Applications" ensure the Windows version is "Windows 10"


*/
{ config, pkgs, lib, ... }:

{
  config = {
    programs.steam.enable = true;
    # These should only be GUI applications that are desired systemwide
    environment.systemPackages = with pkgs; [
      wineWowPackages.staging
      wineWowPackages.waylandFull
      wineWowPackages.fonts
      winetricks
      mono
    ];
    hardware.opengl.driSupport32Bit = true;

    environment.variables = {
      WINEDEBUG = "-all";
      WINEESYNC = "1";
    };
  };
}

