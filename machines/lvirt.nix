{ config, lib, pkgs, ... }:
let
  nixopsRepo = pkgs.fetchFromGitHub {
    owner = "vpsfreecz";
    repo = "nixops";
    rev = "668a0f9de10c04dbb7df8c1e4f2be7b064834432";
    sha256 = "05ahx1snrddb715r1pdbjk1ywfqa829c6wys9icawxygh2ngspki";
  };
in
{
  virtualisation.libvirtd = {
    enable = true;
    networking = {
      enable = true;
      externalIP = "37.205.14.52";
    };
  };

  nixpkgs.overlays = [
    (self: super:
      {
        nixops = (import "${nixopsRepo}/release.nix" {}).build.x86_64-linux;
      }
    )
  ];

  environment.systemPackages = with pkgs; [
    screen
    nixops
    git
  ];

}
