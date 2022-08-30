{ lib, ... }:

{
  config = {
    services.openssh.enable = true;
    services.openssh.passwordAuthentication = false;
    services.openssh.permitRootLogin = lib.mkForce "no";
  };
}

