{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    cargo
    rustc
    clang
    openssl
    pkg-config
    rustfmt
    cargo-cross
    cargo-edit
    cargo-flamegraph
    cargo-asm
    cargo-expand
    cargo-outdated
    rust-analyzer
    rnix-lsp
    nodejs-12_x
    fd
    #zola
    graphviz
  ];
}

