{
  description = "NixOS systems and tools by shinta";

  inputs = {
    # Pin our primary nixpkgs repository. This is the main nixpkgs repository
    # we'll use for our configurations. Be very careful changing this because
    # it'll impact your entire system.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    # We use the unstable nixpkgs repo for some packages.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";

      # We want home-manager to use the same set of nixpkgs as our system.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";

      # We want to use the same set of nixpkgs as our system.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Other packages
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.neovim-flake.url = "github:neovim/neovim?dir=contrib&rev=040f1459849ab05b04f6bb1e77b3def16b4c2f2b";
    };

    fish-foreign-env = {
      url = "github:oh-my-fish/plugin-foreign-env";
      flake = false;
    };

    theme-bobthefish = {
      url = "github:oh-my-fish/theme-bobthefish";
      flake = false;
    };

    fish-fzf = {
      url = "github:jethrokuan/fzf";
      flake = false;
    };

    fish-ghq = {
      url = "github:decors/fish-ghq";
      flake = false;
    };

    tmux-pain-control = {
      url = "github:tmux-plugins/tmux-pain-control";
      flake = false;
    };

    vim-cue = {
      url = "github:jjo/vim-cue";
      flake = false;
    };

    vim-misc = {
      url = "github:mitchellh/vim-misc";
      flake = false;
    };

    tmux-dracula = {
      url = "github:dracula/tmux";
      flake = false;
    };

    vim-fish = {
      url = "github:dag/vim-fish";
      flake = false;
    };

    vim-fugitive = {
      url = "github:tpope/vim-fugitive";
      flake = false;
    };

    vim-dracula = {
      url = "github:dracula/vim";
      flake = false;
    };

    nord-vim = {
      url = "github:arcticicestudio/nord-vim";
      flake = false;
    };

    nvim-treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter";
      flake = false;
    };

    nvim-treesitter-playground = {
      url = "github:nvim-treesitter/playground";
      flake = false;
    };

    nvim-treesitter-textobjects = {
      url = "github:nvim-treesitter/nvim-treesitter-textobjects";
      flake = false;
    };

    nvim-lspconfig = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };

    nvim-lspinstall = {
      url = "github:williamboman/nvim-lsp-installer";
      flake = false;
    };

    nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };

    cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };

    cmp-vsnip = {
      url = "github:hrsh7th/cmp-vsnip";
      flake = false;
    };

    cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };

    vim-vsnip = {
      url = "github:hrsh7th/vim-vsnip";
      flake = false;
    };

    nvim-tree = {
      url = "github:kyazdani42/nvim-tree.lua";
      flake = false;
    };

    vim-tla = {
      url = "github:hwayne/tla.vim";
      flake = false;
    };

    vim-zig = {
      url = "github:ziglang/zig.vim";
      flake = false;
    };

    vim-nord = {
      url = "github:crispgm/nord-vim";
      flake = false;
    };

    nvim-comment = {
      url = "github:numToStr/Comment.nvim";
      flake = false;
    };

    nvim-plenary = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };

    nvim-telescope = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };
    
    vim-terraform = {
      url = "github:hashivim/vim-terraform";
      flake = false;
    };

    zig = {
     url = "github:mitchellh/zig-overlay";
    };
  };

  outputs = { self, nixpkgs, home-manager, theme-bobthefish, fish-fzf, fish-ghq, tmux-pain-control, tmux-dracula, ... }@inputs: let
    fishOverlay = f: p: {
      inherit theme-bobthefish fish-fzf fish-ghq tmux-pain-control tmux-dracula;
    };

    ownVim = import ./users/snt/vim.nix { inherit inputs; };
    nixos = import ./users/snt/nixos.nix { inherit inputs; };

    # Overlays is the list of overlays we want to apply from flake inputs.
    overlays = [
      inputs.neovim-nightly-overlay.overlay
      inputs.zig.overlays.default
      fishOverlay
      ownVim
    ];

    mkVM = import ./lib/mkvm.nix {
      inherit nixpkgs home-manager inputs overlays;
    };
  in {
    nixosConfigurations.vm-aarch64 = mkVM "vm-aarch64" {
      system = "aarch64-linux";
      user = "snt";
      nixos = nixos;
    };

    nixosConfigurations.vm-aarch64-utm = mkVM "vm-aarch64-utm" rec {
      system = "aarch64-linux";
      user = "snt";
      nixos = nixos;
    };

    nixosConfigurations.vm-intel = mkVM "vm-intel" rec {
      system = "x86_64-linux";
      user   = "snt";
      nixos = nixos;
    };
  };
}
