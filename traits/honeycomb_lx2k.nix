{
  boot.kernelParams = [
    # PCIE scaling tends to lock GPUs, jnettlet suggests...
    # "amdgpu.pcie_gen_cap=0x4"
    "radeon.si_support=0"
    "amdgpu.si_support=1"
    # https://discord.com/channels/620838168794497044/665456384971767818/913331830290284544
    "arm-smmu.disable_bypass=0"
    "iommu.passthrough=1"
    "amdgpu.pcie_gen_cap=0x4"
    "usbcore.autosuspend=-1"
    # Serial port
    #"console=ttyAMA0,115200"
    #"earlycon=pl011,mmio32,0x21c0000"
    #"pci=pcie_bus_perf"
    #"arm-smmu.disable_bypass=0" # TODO: remove once firmware supports it
  ];
  boot.kernelModules = [
    "amc6821" # via sensors-detect
  ];
}
