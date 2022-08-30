# This NixOS trait will make your system build entirely from source.
# While fun, this takes some time and sometimes fails.
{ ... }:

{
  config = {
    nixpkgs.overlays = [
      (self: super: {
        stdenv = super.impureUseNativeOptimizations super.stdenv;
      })
    ];
  };
}
