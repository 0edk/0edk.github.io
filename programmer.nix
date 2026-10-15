{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    neovim
    tinycc
    git
  ];

  programs.bash = {
    shellAliases = {
      c = "cat";
      e = "nvim";
      ga = "git add";
      gc = "git commit";
      gd = "git diff";
      gl = "git log";
      gs = "git status";
      ns = "nix shell";
      r = "ls -ahlt | head";
    };
  };
}
