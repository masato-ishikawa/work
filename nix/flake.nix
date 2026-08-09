{
  description = "macOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nix-darwin, ... }: {
    darwinConfigurations.home = nix-darwin.lib.darwinSystem {
      modules = [ ./hosts/home.nix ];
    };

    darwinConfigurations.work = nix-darwin.lib.darwinSystem {
      modules = [ ./hosts/work.nix ];
    };
  };
}
