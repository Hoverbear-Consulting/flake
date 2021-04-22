{ config, pkgs, lib, ... }:

{
  fileSystems."/scratch" = { fsType = "tmpfs"; };

  time.timeZone = "America/Vancouver";
  i18n.defaultLocale = "en_CA.UTF-8";

  environment.systemPackages = with pkgs; [
    # Shell utilities
    patchelf
    direnv
    nix-direnv
    git
    jq
    fzf
    ripgrep
    lsof
    htop
    bat
    grex
    broot
    bottom
    fd
    sd
    fio
    hyperfine
    tokei
    bandwhich
    lsd
    abduco
    dvtm
    neovim-remote
    # System utilities
    nvme-cli
    nvmet-cli
    libhugetlbfs
    killall
    gptfdisk
    fio
    smartmontools
  ];
  environment.shellAliases = { };
  environment.variables = {
    EDITOR = "${pkgs.neovim-remote}/bin/nvr -s";
  };
  environment.pathsToLink = [
    "/share/nix-direnv"
  ];

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  programs.neovim.viAlias = true;
  programs.neovim.vimAlias = true;
  programs.neovim.configure = {
    customRC = builtins.readFile ../config/nvim/nvimrc;
    packages.myVimPackage = with pkgs.vimPlugins; {
      start = [
        LanguageClient-neovim
        awesome-vim-colorschemes
        fugitive
        rust-vim
        vim-nix
        fzf-vim
      ];
    };
  };
  programs.bash.promptInit = ''
    eval "$(${pkgs.starship}/bin/starship init bash)"
  '';
  programs.bash.shellInit = ''
  '';
  programs.bash.loginShellInit = ''
    HAS_SHOWN_NEOFETCH=''${HAS_SHOWN_NEOFETCH:-false}
    if [[ $- == *i* ]] && [[ "$HAS_SHOWN_NEOFETCH" == "false" ]]; then
      ${pkgs.neofetch}/bin/neofetch --config ${../config/neofetch/config}
      HAS_SHOWN_NEOFETCH=true
    fi
  '';
  programs.bash.interactiveShellInit = ''
    eval "$(${pkgs.direnv}/bin/direnv hook bash)"
    source "${pkgs.fzf}/share/fzf/key-bindings.bash"
    source "${pkgs.fzf}/share/fzf/completion.bash"
  '';

  security.sudo.wheelNeedsPassword = false;

  # Use edge NixOS.
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nix.package = pkgs.nixUnstable;

  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.03"; # Did you read the comment?
}
