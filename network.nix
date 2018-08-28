{
  network.description = "48.io infrastructure";

  iot =
    { config, lib, pkgs, ... }:
    {
      imports = [
        ./env.nix
        ./machines/iot.nix
      ];
    };

  lvirt =
    { config, lib, pkgs, ... }:
    {
      imports = [
        ./env.nix
        ./modules/libvirt.nix
        ./machines/lvirt.nix
      ];
    };

  io =
    { config, lib, pkgs, ... }:
    {
      imports = [
        ./env.nix
      ];
    };
}
