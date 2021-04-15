/*
Fetch a Github user's keys and parse it into a list appropriate for `openssh.authorizedKeys.keys`.

You can pass this with just a username, and it will error with the required `sha256` setting.

```nix
let
  keysFromGithub = import ./function/keys-from-github.nix { inherit lib pkgs; };
in {
  users.users.ana.openssh.authorizedKeys.keys = keysFromGithub {
    username = "hoverbear";
    sha256 = lib.fakeSha256;
  };
}
```
*/
{ pkgs, lib }:

{ username, sha256 ? lib.fakeSha256 }: (
  lib.splitString "\n" (builtins.readFile (pkgs.fetchurl {
    url = "https://github.com/${username}.keys";
    inherit sha256;
  }))
)
