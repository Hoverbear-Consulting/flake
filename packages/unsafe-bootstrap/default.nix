{ writeShellApplication, bash, gum, ... }:

writeShellApplication {
  name = "unsafe-bootstrap";
  runtimeInputs = [
    bash
    gum
  ];
  text = builtins.readFile ./unsafe-bootstrap.sh;
}
