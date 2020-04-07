# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    #((toString <nixos-hardware>) + "/lenovo/thinkpad/x250")
    ((toString <nixos-hardware>) + "/dell/xps/13-9380")
  ];

  # on demand
  services.fwupd.enable = false;

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ehci_pci"
    # required on thinkpad
    #"ahci"
    "usb_storage"
    "sd_mod"
    "rtsx_pci_sdmmc"
    "nvme"
  ];
  boot.kernelModules = [ "kvm-intel" ];

  # for zfs
  networking.hostId = "8425e349";
  boot.zfs.enableUnstable = true;

  hardware = {
    bluetooth.enable = true;
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/66F2-49C6";
    fsType = "vfat";
    options = ["nofail"];
  };

  fileSystems."/" = {
    device = "zroot/root/nixos";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "zroot/root/home";
    fsType = "zfs";
    options = ["nofail"];
  };

  fileSystems."/home/joerg/Musik/podcasts" = {
    device = "/home/joerg/gPodder/Downloads";
    fsType = "none";
    options = ["bind" "nofail"];
  };

  fileSystems."/home/joerg/web/privat" = {
    device = "/home/joerg/web/private";
    fsType = "none";
    options = ["bind" "nofail"];
  };

  fileSystems."/tmp" = {
    device = "zroot/root/tmp";
    fsType = "zfs";
    options = ["nofail"];
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
