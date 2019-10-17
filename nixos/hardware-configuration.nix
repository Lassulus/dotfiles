# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    (builtins.fetchGit {
      url = "https://github.com/NixOS/nixos-hardware";
      rev = "54268d11ae4e7a35e6085c5561a8d585379e5c73";
    } + "/dell/xps/13-9380")
  ];

  # on demand
  #services.fwupd.enable = true;

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" "i915"
      ];
    };
    kernelModules = [ "kvm-intel" ];
  };

  # for zfs
  networking.hostId = "8425e349";
  boot.zfs.enableUnstable = true;

  hardware = {
    bluetooth = {
      enable = true;
      extraConfig = ''
        AutoConnect=true
      '';
    };
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
  };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/66F2-49C6";
      fsType = "vfat";
      options = ["nofail"];
    };

  fileSystems."/" =
    { device = "zroot/root/nixos";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "zroot/root/home";
      fsType = "zfs";
      options = ["nofail"];
    };

  fileSystems."/home/joerg/Musik/podcasts" =
    { device = "/home/joerg/gPodder/Downloads";
      fsType = "none";
      options = ["bind" "nofail"];
    };

  fileSystems."/home/joerg/web/privat" =
    { device = "/home/joerg/web/private";
      fsType = "none";
      options = ["bind" "nofail"];
    };

  fileSystems."/tmp" =
    { device = "zroot/root/tmp";
      fsType = "zfs";
      options = ["nofail"];
    };

  nix.maxJobs = lib.mkDefault 8;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
