# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  # Use provided UUIDs instead of blkid probing (required for btrfs subvolumes)
  boot.loader.grub.fsIdentifier = "provided";

  networking.hostName = "shouteinda"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "C.UTF-8";
    LC_IDENTIFICATION = "C.UTF-8";
    LC_MEASUREMENT = "C.UTF-8";
    LC_MONETARY = "C.UTF-8";
    LC_NAME = "C.UTF-8";
    LC_NUMERIC = "C.UTF-8";
    LC_PAPER = "C.UTF-8";
    LC_TELEPHONE = "C.UTF-8";
    LC_TIME = "C.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "dvorak";
  };

  # Configure console keymap
  console.keyMap = "dvorak";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."edk" = {
    isNormalUser = true;
    description = "Eli David Katz";
    # dialout for ttyUSB0 and ilk
    extraGroups = [ "networkmanager" "wheel" "dialout" ];
    packages = with pkgs; [];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes"];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    interception-tools-plugins.caps2esc
    fastfetch
    neovim
    lynx
    file
    tinycc
    librewolf
    (anki.withAddons [ (callPackage /home/edk/2025/gulliver/anki/yukogurafu.nix {}) ])
    rofi
  # sqlite
    # for dark theme under Qt
    qt6Packages.qt6ct
    qt6Packages.qtstyleplugin-kvantum
    ripgrep
    git
    flameshot
    feh
    mpv
    keepassxc
    (sc-im.override { xlsSupport = true; })
    neomutt
    zathura
    wl-clipboard
    android-tools
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

  # caps2esc interception
  systemd.services.udevmon = let intercepts = "${pkgs.interception-tools}/bin"; in
    let udevmonConf = pkgs.writeText "udevmon.yaml" ''
SHELL: [${pkgs.runtimeShell}, -c]
---
- JOB: "${intercepts}/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc | ${intercepts}/uinput -d $DEVNODE"
  DEVICE:
    EVENTS:
      EV_KEY: [KEY_CAPSLOCK, KEY_ESC, KEY_LEFTCTRL]
''; in {

    description = "Interception Tools - udevmon";
    wantedBy = [ "multi-user.target" ];
    serviceConfig.ExecStart = "${intercepts}/udevmon -c ${udevmonConf}";
  };

  programs.sway.enable = true;
  hardware.graphics.enable = true;

  # dark theme
  programs.dconf.profiles.user.databases = [{
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  }];
  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_STYLE_OVERRIDE = "kvantum";
    EDITOR = "nvim";
  };

  #services.hardware.openrgb.enable = true;

  programs.bash.shellAliases = {
    c = "cat";
    e = "nvim";
    ga = "git add";
    gc = "git commit";
    gd = "git diff";
    gl = "git log";
    gs = "git status";
    ns = "nix-shell -p";
    r = "ls -ahlt | head";
  };

  zramSwap = {
    enable = true;
    priority = 100;
    algorithm = "lz4";
    memoryPercent = 50;
  };
}
