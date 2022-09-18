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

  # Use `dconf watch /` to track stateful changes you are doing and store them here.
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      # `gnome-extensions list` for a list
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "trayIconsReloaded@selfmade.pl"
        "Vitals@CoreCoding.com"
        "dash-to-panel@jderose9.github.com"
        "sound-output-device-chooser@kgshank.net"
        "space-bar@luchrioh"
      ];
      favorite-apps = [ "firefox.desktop" "code.desktop" "org.gnome.Terminal.desktop" "spotify.desktop" "virt-manager.desktop" "org.gnome.Nautilus.desktop" ];
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
    };
    # `gsettings get org.gnome.shell.extensions.user-theme name`
    "org/gnome/shell/extensions/user-theme" = {
      name = "palenight";
    };
    "org/gnome/desktop/wm/preferences" = {
      workspace-names = [ "Main" ];
    };
    "org/gnome/shell/extensions/vitals" = {
      show-storage = false;
      show-voltage = true;
      show-memory = true;
      show-fan = true;
      show-temperature = true;
      show-processor = true;
      show-network = true;
    };
    "org/gnome/desktop/background" = {
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/vnc-l.png";
      picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/vnc-d.png";
    };
    "org/gnome/desktop/screensaver" = {
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/vnc-d.png";
      primary-color = "#3465a4";
      secondary-color = "#000000";
    };
  };

  home.packages = with pkgs; [
    gnomeExtensions.user-themes
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.vitals
    gnomeExtensions.dash-to-panel
    gnomeExtensions.sound-output-device-chooser
    gnomeExtensions.space-bar
  ];
  home.sessionVariables.GTK_THEME = "palenight";

  programs.fish.enable = true;

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    userSettings = {
      "workbench.colorTheme" = "Palenight Operator";
      "terminal.integrated.scrollback" = 10000;
      # "editor.formatOnSave" = true;
    };
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      ms-vscode-remote.remote-ssh
      github.vscode-pull-request-github
      editorconfig.editorconfig
      matklad.rust-analyzer
      mkhl.direnv
      jock.svg
      usernamehw.errorlens
      vadimcn.vscode-lldb
      bungcip.better-toml

    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "material-palenight-theme";
        publisher = "whizkydee";
        version = "2.0.2";
        sha256 = "sha256-//EpXe+kKloqbMIZ8kstUKdYB490tQBBilB3Z9FfBNI=";
      }
      {
        name = "todo-tree";
        publisher = "Gruntfuggly";
        version = "0.0.215";
        sha256 = "sha256-WK9J6TvmMCLoqeKWh5FVp1mNAXPWVmRvi/iFuLWMylM=";
      }
    ] ++ (if pkgs.stdenv.isx86_64 then with pkgs.vscode-extensions; [
      ms-python.python
    ] else [ ]);
  };

  xdg.configFile."libvirt/qemu.conf".text = ''
    nvram = ["/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd"]
  '';

  programs.home-manager.enable = true;
  home.stateVersion = "22.05";
}
