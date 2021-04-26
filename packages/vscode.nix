{ vscode-with-extensions, vscode-extensions, vscode-utils }:

vscode-with-extensions.override {
  vscodeExtensions = with vscode-extensions; [
    bbenoist.Nix
    ms-vscode-remote.remote-ssh
    github.vscode-pull-request-github
    editorconfig.editorconfig
    matklad.rust-analyzer
    vadimcn.vscode-lldb
  ] ++ vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "rainglow";
      publisher = "daylerees";
      version = "1.5.2";
      sha256 = "1c/xQYnuJ3BkwfqjMeT2kG1ZsXyjEOypJs0pJbouZMQ=";
    }
    {
      name = "nix-env-selector";
      publisher = "arrterian";
      version = "1.0.7";
      sha256 = "DnaIXJ27bcpOrIp1hm7DcrlIzGSjo4RTJ9fD72ukKlc=";
    }
  ];
}
