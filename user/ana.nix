{ lib, pkgs, ... }:
let
  keysFromGithub = import ../function/keys-from-github.nix { inherit lib pkgs; };
in {
  users.users.ana = {
    isNormalUser = true;
    extraGroups = [ "wheel" "disk" ];
    openssh.authorizedKeys.keys = keysFromGithub {
      username = "hoverbear";
      sha256 = "vlQBLCFRUEQT6F+HEZ42YfILu8Fu7if4an2beaFdeWI=";
    };
  };
}
