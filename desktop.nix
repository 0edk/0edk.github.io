{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    rofi
    qt6Packages.qt6ct
    qt6Packages.qtstyleplugin-kvantum
    flameshot
    feh
    wl-clipboard
  ];
  programs.foot.enable = true;
  programs.sway.enable = true;
  programs.dconf.profiles.user.databases = [{
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  }];
  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_STYLE_OVERRIDE = "kvantum";
    EDITOR = "nvim";
  };
}
