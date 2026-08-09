{ ... }:

{
  imports = [ ../common.nix ];

  # Replace this value before applying the work configuration.
  system.primaryUser = throw "Set the work Mac username in nix/hosts/work.nix";
}
