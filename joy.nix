{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    fastfetch
    (anki.withAddons [ (callPackage ./yukogurafu.nix {}) ])
    typst
    lynx
    libqalculate
  ];
}
