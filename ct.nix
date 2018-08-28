{ config, pkgs, lib, ... }:
{
  # XXX
  nix.useSandbox = false;
  system.activationScripts.specialfs = lib.mkForce
  ''
    specialMount() {
      local device="$1"
      local mountPoint="$2"
      local options="$3"
      local fsType="$4"

      if mountpoint -q "$mountPoint"; then
        local options="remount,$options"
      else
        mkdir -m 0755 -p "$mountPoint"
      fi
      # supress remount warnings in container
      if ! out="$( mount -t "$fsType" -o "$options" "$device" "$mountPoint" 2>&1 )"; then
        echo "$out" | grep -q "cannot remount" || echo "$out"
      fi
    }
    source ${config.system.build.earlyMountScript}
  '';
}
