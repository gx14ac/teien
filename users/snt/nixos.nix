{ pkgs, inputs, ... }:

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
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCp65OPx50HxgWOMX8nJiArVyywWJOQ1hnc60Kq3U+XB+4J1bjseaO+/fplNVlus95fWB2JYYrDMOXko/y75FY+X+VZWqT9YYTJEUwj6VMAMLIelsrVdZUllgwC7njQt8e2o2ihgUeM4TPr+x2c68Zqnw+cJgtOmHWH03s349lJS0+4Pq/gO3dc50RjUqzvEhX4NbJ4st8RHrKkr5hiG/Z7XhXJUtFMhGWDQwBituwyRqogQ9Kkp8aPfAGa8ub09/u80shkrnsEsdtwTSgCqEJfSOGBn2ixd45h5sdLv9ehDNfvKw6YpaGAU9f5B9xiN4YuZ2cWeDJYQurMYxt5rdR/lz2o9ilZw5X3oyLfZCyqDTTEbk+5DtZ27+4g89OetZ4e3G/+cHQdATZAQiROAmWZdeLnuxVgXr8PC7qDTemwej52EneA9HwQTqbgQceav9cU3csWXdkUzrLpX1koV5AzM1XLZVQTc696vY5yIht8LLqS6FlgIyNH7WtEQiJZBUs= shinta@MacBook-Pro"
    ];
  };

  nixpkgs.overlays = import ../../lib/overlays.nix ++ [
    (import ./vim.nix { inherit inputs; })
  ];
}
