{
  description = "NixOS systems and tools by shinta";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    nix-snapd.url = "github:nix-community/nix-snapd";
    nix-snapd.inputs.nixpkgs.follows = "nixpkgs";

    # We use the unstable nixpkgs repo for some packages.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };

    fish-foreign-env = {
      url = "github:oh-my-fish/plugin-foreign-env";
      flake = false;
    };

    theme-bobthefish = {
      url = "github:oh-my-fish/theme-bobthefish";
      flake = false;
    };

    jujutsu.url = "github:martinvonz/jj";

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

    nui-nvim = {
      url = "github:MunifTanjim/nui.nvim";
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
      url = "github:nvim-telescope/telescope.nvim/0.1.8";
      flake = false;
    };
    
    vim-terraform = {
      url = "github:hashivim/vim-terraform";
      flake = false;
    };

    dressing-nvim = {
      url = "github:stevearc/dressing.nvim";
      flake = false;
    };

    github-nvim-theme = {
      url = "github:projekt0n/github-nvim-theme";
      flake = false;
    };

    zig = {
     url = "github:mitchellh/zig-overlay";
     inputs.nixpkgs.follows = "nixpkgs";
    };

    vim-copilot = {
      url = "github:github/copilot.vim/v1.48.0";
      flake = false;
    };

    nvim-codecompanion = {
      url = "github:olimorris/codecompanion.nvim";
      flake = false;
    };

    nvim-conform = {
      url = "github:stevearc/conform.nvim/v9.0.0";
      flake = false;
    };

    nvim-dressing = {
      url = "github:stevearc/dressing.nvim";
      flake = false;
    };

    nvim-gitsigns = {
      url = "github:lewis6991/gitsigns.nvim/v1.0.2";
      flake = false;
    };

    nvim-lualine = {
      url = "github:nvim-lualine/lualine.nvim";
      flake = false;
    };

    nvim-nui = {
      url = "github:MunifTanjim/nui.nvim";
      flake = false;
    };

    nvim-render-markdown = {
      url = "github:MeanderingProgrammer/render-markdown.nvim";
      flake = false;
    };

    nvim-treesitter-context = {
      url = "github:nvim-treesitter/nvim-treesitter-context";
      flake = false;
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
      inputs.zig.overlays.default
      inputs.jujutsu.overlays.default
      fishOverlay
      ownVim
      (final: prev: rec {
        claude-code = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.claude-code;
      })
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
