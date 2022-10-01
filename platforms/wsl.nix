{ pkgs, lib, ... }:

{
  config = {
    wsl.enable = true;
    wsl.defaultUser = "ana";
    i18n.supportedLocales = [ "all" ];
    i18n.defaultLocale = "en_CA.UTF-8";
  };
}
