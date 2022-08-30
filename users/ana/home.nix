{ config, pkgs, ... }:

{
  home.username = "ana";
  home.homeDirectory = "/home/ana";

  programs.git = {
    enable = true;
    userName = "Ana Hobden";
    userEmail = "operator@hoverbear.org";
  };

  programs.home-manager.enable = true;
  home.stateVersion = "22.05";
}
