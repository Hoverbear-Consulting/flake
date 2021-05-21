{ pkgs, ... }:

{
  boot.kernel.sysctl = {
    # TCP Fast Open (TFO)
    "net.ipv4.tcp_fastopen" = 3;
  };
  boot.initrd.availableKernelModules = [
    "usb_storage"
    "nbd"
    "nvme"
  ];
  boot.kernelModules = [
    "coretemp"
  ];
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;

  #virtualisation.docker.enable = true;  

  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowedUDPPorts = [ 22 ];

  #services.tlp.enable = true;
  powerManagement.cpuFreqGovernor = "ondemand";
}
