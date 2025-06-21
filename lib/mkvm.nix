# NixOS system based on our VM setup for a particular architecture.
{ nixpkgs, home-manager, inputs, overlays }:

name:
{
  system,
  user,
  nixos
}:

nixpkgs.lib.nixosSystem rec {
  inherit system;

  modules = [
    { nixpkgs.overlays = overlays; }

    { nixpkgs.config.allowUnfree = true; }

    ../arch/${name}.nix
    ../machines/${name}.nix
    nixos
    home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = import ../users/${user}/home-manager.nix {
        inputs = inputs;
      };
    }

    # We expose some extra arguments so that our modules can parameterize
    # better based on these values.
    {
      config._module.args = {
        currentSystemName = name;
        currentSystem = system;
      };
    }
  ];
}
