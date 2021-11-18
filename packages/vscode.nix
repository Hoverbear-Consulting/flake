{ vscode-with-extensions, vscode-extensions, vscode-utils }:

vscode-with-extensions.override {
  vscodeExtensions = with vscode-extensions; [
    bbenoist.nix
    ms-vscode-remote.remote-ssh
    github.vscode-pull-request-github
    editorconfig.editorconfig
    matklad.rust-analyzer
    # vadimcn.vscode-lldb
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
    {
      name = "better-toml";
      publisher = "bungcip";
      version = "0.3.2";
      sha256 = "g+LfgjAnSuSj/nSmlPdB0t29kqTmegZB5B1cYzP8kCI=";
    }
    {
      name = "gitlens";
      publisher = "eamodio";
      version = "11.5.1";
      sha256 = "Ic7eT8WX2GDYIj/aTu1d4m+fgPtXe4YQx04G0awbwnM=";
    }
    {
      name = "sqltools";
      publisher = "mtxr";
      version = "0.23.0";
      sha256 = "Obo/u2shO6UkOG9V6LDOHrLFFapMGSiu8EVoLU8NdT4=";
    }
    {
      name = "Bookmarks";
      publisher = "alefragnani";
      version = "13.0.1";
      sha256 = "4IZCPNk7uBqPw/FKT5ypU2QxadQzYfwbGxxT/bUnKdE=";
    }
  ];
}
