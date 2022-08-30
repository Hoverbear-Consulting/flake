{ lib, ... }:

{
  config = {
    services.openssh.enable = true;
    services.openssh.passwordAuthentication = false;
    services.openssh.permitRootLogin = lib.mkForce "no";

    networking.firewall.allowedTCPPorts = [ 22 ];
    networking.firewall.allowedUDPPorts = [ 22 ];

    services.openssh.hostKeys = [
      {
        path = "/persist/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
      {
        path = "/persist/ssh/ssh_host_rsa_key";
        type = "rsa";
        bits = 4096;
      }
    ];
  };
}

