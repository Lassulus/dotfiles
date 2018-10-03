{ config, lib, ... }: 

let
  sanCertificate = domain: let
    wantedVhosts = lib.filterAttrs (_: attrs: (attrs.useACMEHost or null) == domain) 
      config.services.nginx.virtualHosts;
  in {
    extraDomains = lib.mapAttrs (name: _: null) wantedVhosts;
    postRun = "systemctl reload nginx.service";
    webroot = "/var/lib/acme/acme-challenge";
  };
in {
  imports = [
    ./adminer.nix
    ./blog.halfco.de.nix
    ./blog.nix
    ./btsync.nix
    ./devkid.net.nix
    ./dl.nix
    ./halfco.de.nix
    ./homepage.nix
    ./ip.nix
    ./ist.devkid.net.nix
    ./ldapadmin.nix
    ./muc.nix
    ./owncloud.nix
    ./piwik.nix
    ./pyload.nix
    ./rainloop.nix
    #./threema.nix
  ];

  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    appendHttpConfig = ''
      # TODO check later if this is required for ssl_stapling
      #ssl_trusted_certificate ${./isrgrootx1.pem.txt}
      add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload";
      add_header X-Frame-Options DENY;
      add_header X-Content-Type-Options nosniff;
    '';

    # owncloud etc
    clientMaxBodySize = "4G";

    resolver.addresses = ["172.23.75.6"];

    sslDhparam = config.security.dhparams.params.nginx.path;

  };

  security.dhparams = {
    enable = true;
    params.nginx = {};
  };

  #security.acme.production = false;
  security.acme.certs = {
    "thalheim.io" = sanCertificate "thalheim.io";
    "devkid.net" = sanCertificate "devkid.net";
    "halfco.de" = sanCertificate "halfco.de";
    "higgsboson.tk" = sanCertificate "higgsboson.tk";
  };
}