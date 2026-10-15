{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    librewolf
    mpv
    keepassxc
    (sc-im.override { xlsSupport = true; })
    neomutt
    zathura
  ];
}
