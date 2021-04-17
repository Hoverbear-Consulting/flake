{ lib, pkgs, ... }:
let
  keysFromGithub = import ../function/keys-from-github.nix { inherit lib pkgs; };
in {
  users.users.ana = {
    isNormalUser = true;
    extraGroups = [ "wheel" "disk" ];
    openssh.authorizedKeys.keys = keysFromGithub {
      username = "hoverbear";
      # sha256 = lib.fakeSha256;
      sha256 = "hHUVZ5xWZqLffeb9soyCwXA1wcCSy5lpyeKPHhlDl08=";
    };
  };
}
