{ pkgs, ... }:

{
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.zfsSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev";
  boot.kernel.sysctl = {
    # TCP Fast Open (TFO)
    "net.ipv4.tcp_fastopen" = 3;
  };
  boot.initrd.availableKernelModules = [
    "usb_storage"
    "nbd"
    "nvme"
    "nvmet"
    "nvme_fabrics"
    "nvmet_rdma"
    "nvme_tcp"
    "nvme_rdma"
    "nvme_loop"
  ];
  boot.kernelParams = [
    "hugepagesz=64K"
    "hugepages=4096"
    "hugepagesz=2M"
    "hugepages=4096"
    "hugepagesz=1G"
    "hugepages=4"
    "cgroup_enable=cpuset"
    "cgroup_memory=1"
    "cgroup_enable=memory"
  ];
  boot.kernelModules = [
    "coretemp"
  ];
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;

  #virtualisation.docker.enable = true;  

  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowedUDPPorts = [ 22 ];
  
  services.tlp.enable = true;
  powerManagement.cpuFreqGovernor = "ondemand";
}
