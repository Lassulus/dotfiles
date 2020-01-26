with (import <nixpkgs> {}).callPackage ../krops.nix {
  name = "eve";
};

pkgs.krops.writeDeploy "deploy" {
  source = lib.evalSource [{
    nixpkgs.file = nixpkgs.file;
    inherit dotfiles nixos-config secrets shared-secrets;
  }];
  target = "root@eve.thalheim.io";
  #target = "root@129.215.90.4";
}