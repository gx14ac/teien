{ inputs }:

{ config, lib, pkgs, ... }:

{
  # https://github.com/nix-community/home-manager/pull/2408
  environment.pathsToLink = [ "/share/fish" ];

  programs.fish.enable = true;

  users.users.snt = {
    isNormalUser = true;
    home = "/home/snt";
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.fish;
    hashedPassword = "$6$ZM/qkIwlMmiy1S4$onu2GWYF/UnkaMIpKxl.Ppk/Nn61F6vKy0uNHkkHRuwzT3t2thQp7YS5SWwmGmFqxsbY2fA9rVTyxb8Kod9Yi.";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF3kiF4p3HL/xzksXTXly/8EModJ5uUYBe02FQDLlciZ shinta@shinta"
    ];
  };

  nixpkgs.overlays = import ../../lib/overlays.nix ++ [
    (import ./vim.nix { inherit inputs; })
  ];
}
