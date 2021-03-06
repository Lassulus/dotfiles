{ config, lib, pkgs, ... }:

{
  sops.secrets.telegraf.owner = config.systemd.services.telegraf.serviceConfig.User;
  sops.secrets.telegraf-shared = {
    owner = config.systemd.services.telegraf.serviceConfig.User;
    sopsFile = ../../secrets/telegraf.yaml;
  };
  systemd.services.telegraf.serviceConfig.SupplementaryGroups = [ "keys" ];

  imports = [
    ../../modules/telegraf.nix
  ];

  services.nginx.virtualHosts."telegraf.thalheim.io" = {
    forceSSL = true;
    enableACME = true;
    locations."/".extraConfig =  ''
      proxy_pass http://localhost:8186/;
    '';
  };

  services.telegraf = {
    environmentFiles = [
      config.sops.secrets.telegraf.path
      config.sops.secrets.telegraf-shared.path
    ];
    extraConfig = {
      agent.interval = "120s";
      inputs = {
        influxdb_v2_listener = [{
          service_address = ":8186";
          token = ''''${INFLUXDB_PASSWORD}'';
        }];
        ping = let
          urls = [
            "eve.r"
            "eve.thalheim.io"

            # university
            "rose.r"
            "martha.r"
            "donna.r"
            "amy.r"
            "clara.r"
            "doctor.r"
          ];
          mobileUrls = [
            "turingmachine.r"
            "herbert.r"
          ];
        in [{
          method = "native";
          urls = map (url: "${url}") mobileUrls;
          tags.type = "mobile";
          count = 5;
        } {
          method = "native";
          urls = map (url: "4.${url}") urls;
        } {
          method = "native";
          urls = map (url: "6.${url}") urls;
          ipv6 = true;
        }];

        # dovecot
        net_response = [{
          # imap
          protocol = "tcp";
          address = "imap.thalheim.io:143";
        } {
          # imaps
          protocol = "tcp";
          address = "imap.thalheim.io:993";
        } {
          # sieve
          protocol = "tcp";
          address = "imap.thalheim.io:4190";
        } {
          # xmpp-client
          protocol = "tcp";
          address = "jabber.thalheim.io:5222";
        } {
          # xmpp-server
          protocol = "tcp";
          address = "jabber.thalheim.io:5269";
        } {
          # openldap
          protocol = "tcp";
          address = "eve.r:389";
        } {
          # openldap
          protocol = "tcp";
          address = "eva.r:389";
        } {
          # postfix: smtp
          protocol = "tcp";
          # amazon does block port 25
          address = "eve.r:25";
        } {
          # postfix: submission
          protocol = "tcp";
          address = "mail.thalheim.io:587";
        } {
          # postfix: smtps
          protocol = "tcp";
          address = "mail.thalheim.io:465";
        }] ++ map (address: {
          protocol = "tcp";
          inherit address;
          send = "SSH-2.0-Telegraf";
          expect = "SSH-2.0";
        }) [
          "eve.thalheim.io:22"
          "rock.r:22"
          "eve.r:22"
          "amy.r:22"
          "donna.r:22"
          "clara.r:22"
          "martha.r:22"
          "rose.r:22"
          "doctor.r:22"
        ];

        http = [{
          urls = [
            "https://api.github.com/repos/Mic92/nur-packages/commits/master/check-suites"
            "https://api.github.com/repos/Mic92/sops-nix/commits/master/check-suites"
          ];
          data_format = "json";
          json_query = "check_suites.#(app.id == 15368)";
        }];

        http_response = [{
          urls = [ "http://yellow.r:9091/transmission/web/" ];
          response_string_match = "Transmission Web";
          tags.org = "krebs";
        } {
          urls = [
            "http://helsinki.r"
            "http://yellow.r"
          ];
          response_string_match = "Index of /";
          tags.org = "krebs";
        } {
          urls = [
            "http://wiki.r/Home"
          ];
          response_string_match = "gollum";
          tags.org = "krebs";
        } {
          urls = [
            "http://graph.r"
          ];
          response_string_match = "Retiolum";
          tags.org = "krebs";
        } {
          urls = [
            "http://cgit.ni.r"
            "http://cgit.enklave.r"
            "http://cgit.gum.r"
            "http://cgit.prism.r"
          ];
          response_string_match = "cgit";
          tags.org = "krebs";
        } {
          urls = [
            "http://build.hotdog.r"
          ];
          response_string_match = "BuildBot";
          tags.org = "krebs";
        } {
          urls = [
            "http://paste.r/"
          ];
          response_string_match = "Bepasty";
          tags.org = "krebs";
        } {
          urls = [
            "http://p.r/1pziljc"
          ];
          response_string_match = "ok";
          tags.org = "krebs";
        } {
          urls = [ "https://www.wikipedia.org/" ];
          http_proxy = ''https://telegraf%40thalheim.io:''${LDAP_PASSWORD}@devkid.net:8889'';
          response_string_match = "wikipedia.org";
        } {
          urls = [ "https://adminer.thalheim.io/" ];
          response_string_match = "Login";
        } {
          urls = [ "https://mail.thalheim.io" ];
          response_string_match = "javascript";
        } {
          urls = [ "https://ist.devkid.net/wiki/Hauptseite" ];
          response_string_match = "Informationssystemtechnik";
        } {
          urls = [ "https://rss.devkid.net" ];
        } {
          urls = [ "https://rspamd.thalheim.io" ];
          response_string_match = "Rspamd";
        } {
          urls = [ "https://glowing-bear.thalheim.io" ];
          response_string_match = "Glowing";
        } {
          urls = [ "https://grafana.thalheim.io/login" ];
          response_string_match = "Grafana";
        } {
          urls = [ "https://dl.thalheim.io/OtNjoZOUnEn3H6LJZ1qcIw/test" ];
        } {
          urls = [ "https://dns.thalheim.io/dns-query?dns=q80BAAABAAAAAAAAA3d3dwdleGFtcGxlA2NvbQAAAQAB" ];
          response_string_match = "example";
        } {
          urls = [ "https://syncthing.thalheim.io" ];
          username = "syncthing";
          password = "$SYNCTHING_PASSWORD";
          response_string_match = "Syncthing";
        } {
          urls = [ "https://git.thalheim.io" ];
          response_string_match = "Gitea";
        } {
          urls = [ "https://thalheim.io" ];
          response_string_match = "Higgs-Boson";
        } {
          urls = [ "http://loki.r/ready" ];
          response_string_match = "ready";
        } {
          urls = [
            "https://cloud.thalheim.io/login"
            "https://pim.devkid.net/login"
          ];
          response_string_match = "Nextcloud";
        } {
          urls = ["https://influxdb.thalheim.io:8086/ping"];
        }];

        dns_query = {
          servers = [
            "ns1.thalheim.io"
            "ns2.he.net"
            "ns3.he.net"
            "ns4.he.net"
            "ns5.he.net"
          ];
          domains = [
            "lekwati.com"
            "thalheim.io"
          ];
          record_type = "A";
        };

        x509_cert = {
          sources = [
            # nginx
            "https://prometheus.thalheim.io:443"
            "https://alertmanager.thalheim.io:443"
            "https://devkid.net:443"
            "https://thalheim.io:443"
            # squid
            "https://devkid.net:8889"
            # dovecot
            "tcp://imap.thalheim.io:993"
            "tcp://imap.devkid.net:993"
            #  postfix
            "tcp://mail.thalheim.io:465"
          ];
        };
      };
    };
  };
}
