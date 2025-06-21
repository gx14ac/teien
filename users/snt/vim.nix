{ inputs, ... }:

self: super:

{
  customVim = with self; {
    vim-copilot = vimUtils.buildVimPlugin {
      name = "vim-copilot";
      src = inputs.vim-copilot;
    };

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
      src = inputs.vim-dracula;
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
      doCheck = false;
    };

    vim-tla = vimUtils.buildVimPlugin {
      name = "tla.vim";
      src = inputs.vim-tla;
    };

    vim-zig = vimUtils.buildVimPlugin {
      name = "zig.vim";
      src = inputs.vim-zig;
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
      doCheck = false;
    };

    nvim-telescope = vimUtils.buildVimPlugin {
      name = "nvim-telescope";
      src = inputs.nvim-telescope;
      buildPhase = ":";
      doCheck = false;
    };

    dressing-nvim = vimUtils.buildVimPlugin {
      name = "dressing.nvim";
      src = inputs.dressing-nvim;
      buildPhase = ":";
    };

    vim-terraform = vimUtils.buildVimPlugin {
      name = "vim-terraform";
      src = inputs.vim-terraform;
      buildPhase = ":";
    };

    avante-nvim-lib = super.pkgs.rustPlatform.buildRustPackage {
      pname = "avante-nvim-lib";
      version = "flake";
      src = inputs.avante-nvim;

      useFetchCargoVendor = true;
      cargoHash = "sha256-pmnMoNdaIR0i+4kwW3cf01vDQo39QakTCEG9AXA86ck=";

      nativeBuildInputs = with super.pkgs; [
        pkg-config
        perl
      ];

      buildInputs = with super.pkgs; [
        openssl
      ];

      buildFeatures = ["luajit"];

      checkFlags = [
        # Disabled because they access the network.
        "--skip=test_hf"
        "--skip=test_public_url"
        "--skip=test_roundtrip"
        "--skip=test_fetch_md"
      ];
    };

    avante-nvim = vimUtils.buildVimPlugin {
      name = "avante-nvim";
      src = inputs.avante-nvim;
      dependencies = [
        customVim.nvim-plenary
        customVim.nui-nvim
        customVim.nvim-treesitter
        customVim.dressing-nvim
      ];
      postInstall = let
        ext = super.pkgs.stdenv.hostPlatform.extensions.sharedLibrary;
      in ''
        mkdir -p $out/build
        ln -s ${customVim.avante-nvim-lib}/lib/libavante_repo_map${ext} $out/build/avante_repo_map${ext}
        ln -s ${customVim.avante-nvim-lib}/lib/libavante_templates${ext} $out/build/avante_templates${ext}
        ln -s ${customVim.avante-nvim-lib}/lib/libavante_tokenizers${ext} $out/build/avante_tokenizers${ext}
      '';
    };

    nui-nvim = vimUtils.buildVimPlugin {
      name = "nui.nvim";
      src = inputs.nui-nvim;
      buildPhase = ":";
    };

    github-nvim-theme = vimUtils.buildVimPlugin {
      name = "github-nvim-theme";
      src = inputs.github-nvim-theme;
      buildPhase = ":";
    };
  
    nvim-codecompanion = vimUtils.buildVimPlugin {
      name = "nvim-codecompanion";
      src = inputs.nvim-codecompanion;
      doCheck = false;
    };

    nvim-dressing = vimUtils.buildVimPlugin {
      name = "nvim-dressing";
      src = inputs.nvim-dressing;
    };

    nvim-conform = vimUtils.buildVimPlugin {
      name = "nvim-conform";
      src = inputs.nvim-conform;
    };

    nvim-gitsigns = vimUtils.buildVimPlugin {
      name = "nvim-gitsigns";
      src = inputs.nvim-gitsigns;
    };

    nvim-lualine = vimUtils.buildVimPlugin {
      name = "nvim-lualine";
      src = inputs.nvim-lualine;
    };

    nvim-nui = vimUtils.buildVimPlugin {
      name = "nvim-nui";
      src = inputs.nvim-nui;
    
    };

    nvim-render-markdown = vimUtils.buildVimPlugin {
      name = "nvim-render-markdown";
      src = inputs.nvim-render-markdown;
    };

    nvim-treesitter-context = vimUtils.buildVimPlugin {
      name = "nvim-treesitter-context";
      src = inputs.nvim-treesitter-context;
      doCheck = false;
    };
  };
}
