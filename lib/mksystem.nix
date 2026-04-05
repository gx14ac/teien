# This function creates a system (NixOS or nix-darwin) based on our setup
{ nixpkgs, home-manager, inputs, overlays }:

name:
{
  system,
  user,
  configDir ? user,
  darwin ? false
}:

let
  # True if this is a Darwin (macOS) system
  isDarwin = darwin;

  # True if this is a Linux system
  isLinux = !darwin;

  # The config files for this system
  machineConfig =
    if isDarwin
    then ../machines/${name}.nix
    else ../machines/${name}.nix;

  userOSConfig = ../users/${configDir}/${if darwin then "darwin" else "nixos"}.nix;
  userHMConfig = ../users/${configDir}/home-manager.nix;

  # NixOS vs nix-darwin functions
  systemFunc = if isDarwin then inputs.darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;
  home-manager-module = if isDarwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;
in systemFunc rec {
  inherit system;

  modules = [
    # Apply our overlays globally
    { nixpkgs.overlays = overlays; }

    # Allow unfree packages
    { nixpkgs.config.allowUnfree = true; }

    # Include arch config for Linux VMs
    (if isLinux then ../arch/${name}.nix else {})

    machineConfig
    userOSConfig
    home-manager-module.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = import userHMConfig {
        inputs = inputs;
        isDarwin = isDarwin;
      };
    }

    # Expose extra arguments for parameterization
    {
      config._module.args = {
        currentSystem = system;
        currentSystemName = name;
        currentSystemUser = user;
        isDarwin = isDarwin;
        inputs = inputs;
      };
    }
  ];
}
