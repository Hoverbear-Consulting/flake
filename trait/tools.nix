{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    cargo
    rustc
    clang
    rustfmt
    cargo-cross
    cargo-edit
    cargo-flamegraph
    cargo-asm
    cargo-expand
    cargo-outdated
    rust-analyzer
    nodejs-12_x
    zola
  ];
}

