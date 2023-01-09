# NixOS system based on our VM setup for a particular architecture.
name: { nixpkgs, home-manager, inputs, system, user, overlays, nixos }:

nixpkgs.lib.nixosSystem rec {
  inherit system;

  modules = [
    { nixpkgs.overlays = overlays; }

    ../arch/${name}.nix
    ../machines/${name}.nix
    nixos
    home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = (import ../users/${user}/home-manager.nix);
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
