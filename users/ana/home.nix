{ config, pkgs, lib, ... }:

{
  home.username = "ana";
  home.homeDirectory = "/home/ana";

  programs.git = {
    enable = true;
    userName = "Ana Hobden";
    userEmail = "operator@hoverbear.org";
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "palenight";
      package = pkgs.palenight-theme;
    };
    cursorTheme = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };
  
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      # `gnome-extensions list` for a list
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "trayIconsReloaded@selfmade.pl"
      ];
    };
    "org/gnome/shell/extensions/user-theme" = {
      name = "palenight";
    };
  };

  home.packages = with pkgs; [
    gnomeExtensions.user-themes
    gnomeExtensions.tray-icons-reloaded
  ];
  home.sessionVariables.GTK_THEME = "palenight";

  programs.fish.enable = true;
  
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    userSettings = {
      "workbench.colorTheme" = "Palenight Operator";
    };
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      ms-vscode-remote.remote-ssh
      github.vscode-pull-request-github
      editorconfig.editorconfig
      matklad.rust-analyzer
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "material-palenight-theme";
        publisher = "whizkydee";
        version = "2.0.2";
        sha256 = "sha256-//EpXe+kKloqbMIZ8kstUKdYB490tQBBilB3Z9FfBNI=";
      }
      {
        name = "better-toml";
        publisher = "bungcip";
        version = "0.3.2";
        sha256 = "g+LfgjAnSuSj/nSmlPdB0t29kqTmegZB5B1cYzP8kCI=";
      }
      {
        name = "Bookmarks";
        publisher = "alefragnani";
        version = "13.3.1";
        sha256 = "4IZCPNk7uBqPw/FKT5ypU2QxadQzYfwbGxxT/bUnKdE=";
      }
      {
        name = "todo-tree";
        publisher = "Gruntfuggly";
        version = "0.0.215";
        sha256 = "sha256-WK9J6TvmMCLoqeKWh5FVp1mNAXPWVmRvi/iFuLWMylM=";
      }
    ];
  };

  programs.home-manager.enable = true;
  home.stateVersion = "22.05";
}
