{ writeShellApplication, bash, gum, cryptsetup, gptfdisk, btrfs-progs, ... }:

writeShellApplication {
  name = "unsafe-bootstrap";
  runtimeInputs = [
    bash
    gum
    cryptsetup
    gptfdisk
    btrfs-progs

  ];
  text = builtins.readFile ./unsafe-bootstrap.sh;
}
