/*
  A container running `../trait/postgres.nix`.

  ```nix
  # flake .nix
  {
  #
  inputs = {
  nixos.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.hoverbear.url = "github:hoverbear-consulting/nix";
  };
  outputs = { self, nixos, hoverbear-consulting }: {
  # ...
  nixosConfigurations = {
  container-host = nixos.lib.nixosSystem {
  # ...
  modules = [
  # ...
  hoverbear-consulting.nixosModues.container-postgres
  ];
  };
  };
  # ...
  };
  }
  ```
*/
{ self, ... }:

{
  containers = {
    postgres = {
      autoStart = true;
      config = self.nixosModules.trait-postgres;
    };
  };
}
