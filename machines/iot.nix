{ config, lib, pkgs, ... }:
let
  ttnEnv = pkgs.writeText "ttn-client-config" ''
    [app]
    id = basetest
    host = eu.thethings.network
    port = 1883
    key = ${ lib.fileContents ../static/ttn-api-key.secret }
  '';

  app = import /home/rmarko/git/ttn-om/app.nix {
    prod = true;
    #prodWsURL = "ws://iot.48.io/ws";
    prodWsURL = "wss://iot.otevrenamesta.cz/ws";
  };

  appPort = 31337;
  wsPort = 8000;
in
{

  networking.firewall.allowedTCPPorts = [ 80 ];

  networking.extraHosts = ''
    52.169.76.255 eu.thethings.network
  '';

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts = {
      "default" = {
        default = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${ toString appPort }";
        };
        locations."/ws" = {
          proxyPass = "http://127.0.0.1:${ toString wsPort }";
          extraConfig = ''
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host $host;
          '';
        };
      };
    };
  };

  systemd.services.dashboard = {
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    environment.TTNCFG = ttnEnv;
    serviceConfig =
      { Restart = "always";
        RestartSec = 3;
        Type = "simple";
        ExecStart = "${app.combined}/bin/server ${ toString appPort } ${ toString wsPort }";
        WorkingDirectory = app.combined;
      };
  };
}
