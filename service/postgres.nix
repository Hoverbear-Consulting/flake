{ pkgs, ... }:

{
  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql_12;
  services.postgresql.extraPlugins = with pkgs.postgresql_12.pkgs; [
    # postgis
  ];
  services.postgresql.initialScript = pkgs.writeText "bootstrap" ''
    CREATE ROLE root WITH LOGIN;
    CREATE DATABASE root;
    GRANT ALL PRIVILEGES ON DATABASE root TO root;
  '';
}
