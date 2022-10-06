{ writeShellApplication, patchelf, ... }:

writeShellApplication {
  name = "fix-vscode";
  runtimeInputs = [
    patchelf
  ];
  checkPhase = "";
  text = builtins.readFile ./fix-vscode.sh;
}
