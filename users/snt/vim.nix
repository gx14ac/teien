{ inputs, ... }:

self: super:

{
  customVim = with self; {
    vim-cue = vimUtils.buildVimPlugin {
      name = "vim-cue";
      src = inputs.vim-cue;
    };

    vim-fish = vimUtils.buildVimPlugin {
      name = "vim-fish";
      src = inputs.vim-fish;
    };

    vim-fugitive = vimUtils.buildVimPlugin {
      name = "vim-fugitive";
      src = inputs.vim-fugitive;
    };

    vim-dracula = vimUtils.buildVimPlugin {
      name = "vim-dracula";
      src = input.svim-dracula;
    };

    nord-vim = vimUtils.buildVimPlugin {
      name = "nord-vim";
      src = inputs.nord-vim;
    };

    nvim-treesitter = vimUtils.buildVimPlugin {
      name = "nvim-treesitter";
      src = inputs.nvim-treesitter;
    };

    nvim-treesitter-playground = vimUtils.buildVimPlugin {
      name = "nvim-treesitter-playground";
      src = inputs.nvim-treesitter-playground;
    };

    nvim-treesitter-textobjects = vimUtils.buildVimPlugin {
      name = "nvim-treesitter-textobjects";
      src = inputs.nvim-treesitter-textobjects;
    };

    nvim-lspconfig = vimUtils.buildVimPlugin {
      name = "nvim-lspconfig";
      src = inputs.nvim-lspconfig;

      buildPhase = ":";
    };

    nvim-lspinstall = vimUtils.buildVimPlugin {
      name = "nvim-lspinstall";
      src = inputs.nvim-lspinstall;
    };

    nvim-cmp = vimUtils.buildVimPlugin {
      name = "nvim-cmp";
      src = inputs.nvim-cmp;

      buildPhase = ":";
    };

    AfterColors = vimUtils.buildVimPlugin {
      name = "AfterColors";
      src = pkgs.fetchFromGitHub {
        owner = "vim-scripts";
        repo = "AfterColors.vim";
        rev = "9936c26afbc35e6f92275e3f314a735b54ba1aaf";
        sha256 = "0j76g83zlxyikc41gn1gaj7pszr37m7xzl8i9wkfk6ylhcmjp2xi";
      };
    };

    vim-misc = vimUtils.buildVimPlugin {
      name = "vim-misc";
      src = inputs.vim-misc;
    };

    vim-tla = vimUtils.buildVimPlugin {
      name = "tla.vim";
      src = inputs.vim-tla;
    };

    vim-zig = vimUtils.buildVimPlugin {
      name = "zig.vim";
      src = inputs.vim-zig;
    };

    vim-copilot = vimUtils.buildVimPlugin {
      name = "vim-copilot";
      src = inputs.vim-copilot;
    };

    cmp-nvim-lsp = vimUtils.buildVimPlugin {
      name = "cmp-nvim-lsp";
      src = inputs.cmp-nvim-lsp;
    };

    cmp-vsnip = vimUtils.buildVimPlugin {
      name = "cmp-vsnip";
      src = inputs.cmp-vsnip;
    };

    cmp-buffer = vimUtils.buildVimPlugin {
      name = "cmp-buffer";
      src = inputs.cmp-buffer;
    };

    vim-vsnip = vimUtils.buildVimPlugin {
      name = "vim-vsnip";
      src = inputs.vim-vsnip;
    };

    nvim-tree = vimUtils.buildVimPlugin {
      name = "nvim-tree";
      src = inputs.nvim-tree;
    };

    vim-nord = vimUtils.buildVimPlugin {
      name = "vim-nord";
      src = inputs.vim-nord;
    };

    nvim-comment = vimUtils.buildVimPlugin {
      name = "nvim-comment";
      src = inputs.nvim-comment;
    };

    nvim-lsp-config = vimUtils.buildVimPlugin {
      name = "nvim-lsp-config";
      src = inputs.nvim-lsp-config;
    };

    nvim-plenary = vimUtils.buildVimPlugin {
      name = "nvim-plenary";
      src = inputs.nvim-plenary;
      buildPhase = ":";
    };

    nvim-telescope = vimUtils.buildVimPlugin {
      name = "nvim-telescope";
      src = inputs.nvim-telescope;
      buildPhase = ":";
    };

    vim-terraform = vimUtils.buildVimPlugin {
      name = "vim-terraform";
      src = inputs.vim-terraform;
      buildPhase = ":";
    };
  };
}
