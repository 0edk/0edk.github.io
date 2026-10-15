# adapted from hugosenari/nixos-config
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
  };
  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations.shouteinda = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hardware-configuration.nix
        ./desktop.nix
        ./input.nix
        ./joy.nix
        ./programmer.nix
        ./society.nix
        ./tools.nix
        {
          system.stateVersion = "26.05";
          boot.loader.grub = {
            enable = true;
            device = "/dev/sda";
            useOSProber = true;
            fsIdentifier = "provided";
          };
          users.users.edk = {
            isNormalUser = true;
            description = "Eli David Katz";
            extraGroups = [ "wheel" "networkmanager" "dialout" ];
          };
          networking.hostName = "shouteinda";
          networking.wireless = {
            enable = true;
            userControlled = true;
            networks."umd-iot" = {
              psk = "pVcSXUmLWQmX";
            };
          };
          time.timeZone = "America/New_York";
          zramSwap = {
            enable = true;
            priority = 100;
            algorithm = "lz4";
            memoryPercent = 50;
          };
          nix.settings.experimental-features = [ "nix-command" "flakes" ];
        }
      ];
    };
  };
}
