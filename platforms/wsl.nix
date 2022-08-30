{ pkgs, lib, ... }:

{
  config = {
    boot.wsl.enable = true;
    boot.wsl.user = "ana";
    i18n.supportedLocales = [ "all" ];
    i18n.defaultLocale = "en_CA.UTF-8";
  };
}
