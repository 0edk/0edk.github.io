{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    file
    ripgrep
    android-tools
    busybox
  ];
}
