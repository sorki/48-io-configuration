let

  vpsadminos = builtins.fetchTarball https://github.com/vpsfreecz/vpsadminos/archive/master.tar.gz;

in

{
  iot =
    { config, lib, pkgs, ... }:
    {
      imports = [
        <nixpkgs/nixos/modules/virtualisation/container-config.nix>
        "${vpsadminos}/os/lib/nixos-container/build.nix"
        "${vpsadminos}/os/lib/nixos-container/networking.nix"

        ./ct.nix
      ];

      # 10879 nixos00
      #deployment.targetHost = "37.205.14.2";
      deployment.targetHost = "iot";
      deployment.targetEnv = "dumb";
    };

  lvirt =
    { config, lib, pkgs, ... }:
    {
      imports = [
        <nixpkgs/nixos/modules/virtualisation/container-config.nix>
        "${vpsadminos}/os/lib/nixos-container/build.nix"
        "${vpsadminos}/os/lib/nixos-container/networking.nix"

        ./ct.nix
      ];

      #11024 nixos01
      #deployment.targetHost = "nixos01";
      deployment.targetHost = "37.205.14.52";
      deployment.targetEnv = "dumb";

    };

  io =
    { config, lib, pkgs, ... }:
    {
      imports = [
        <nixpkgs/nixos/modules/virtualisation/container-config.nix>
        "${vpsadminos}/os/lib/nixos-container/build.nix"
        "${vpsadminos}/os/lib/nixos-container/networking.nix"

        ./ct.nix
      ];

      #11458 nixos02
      #deployment.targetHost = "nixos02";
      deployment.targetHost = "37.205.14.89";
      deployment.targetEnv = "dumb";

    };
}
