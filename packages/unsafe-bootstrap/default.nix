{ writeShellApplication, bash, gum, ... }:

writeShellApplication {
  name = "unsafe-bootstrap";
  runtimeInputs = [
    bash
    gum
    cryptsetup

  ];
  text = builtins.readFile ./unsafe-bootstrap.sh;
}
