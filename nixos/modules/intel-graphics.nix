{ pkgs, ...}:
{
  hardware.opengl = {
    enable = true;
    extraPackages = [ pkgs.vaapiIntel ];
    driSupport32Bit = true;
  };
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
}
