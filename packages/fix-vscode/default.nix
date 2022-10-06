{ writeShellApplication, patchelf, ... }:

writeShellApplication {
  name = "fix-vscode";
  runtimeInputs = [
    patchelf
  ];
  text = builtins.readFile ./fix-vscode.sh;
}
