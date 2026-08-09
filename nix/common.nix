{ ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.defaults.dock.autohide = false;

  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
