{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        bbenoist.Nix
        ms-vscode-remote.remote-ssh
        matklad.rust-analyzer
        vadimcn.vscode-lldb
        ms-vsliveshare.vsliveshare
        github.vscode-pull-request-github
        editorconfig.editorconfig
      ] ++ vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "rainglow";
          publisher = "daylerees";
          version = "1.5.2";
          sha256 = "1c/xQYnuJ3BkwfqjMeT2kG1ZsXyjEOypJs0pJbouZMQ=";
        }
        {
          name = "nix-env-selector";
          publisher = "arrterian";
          version = "1.0.7";
          sha256 = "DnaIXJ27bcpOrIp1hm7DcrlIzGSjo4RTJ9fD72ukKlc=";
        }
      ];
    })
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
