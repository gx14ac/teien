{ pkgs }:
''
"--------------------------------------------------------------------
" Fix vim paths so we load the vim-misc directory
let g:vim_home_path = "~/.vim"

" This works on NixOS 21.05
let vim_misc_path = split(&packpath, ",")[0] . "/pack/home-manager/start/vim-misc/vimrc.vim"
if filereadable(vim_misc_path)
  execute "source " . vim_misc_path
endif

" This works on NixOS 21.11
let vim_misc_path = split(&packpath, ",")[0] . "/pack/home-manager/start/vimplugin-vim-misc/vimrc.vim"
if filereadable(vim_misc_path)
  execute "source " . vim_misc_path
endif

" This works on NixOS 22.11
let vim_misc_path = split(&packpath, ",")[0] . "/pack/myNeovimPackages/start/vimplugin-vim-misc/vimrc.vim"
if filereadable(vim_misc_path)
  execute "source " . vim_misc_path
endif

set ts=4 sw=4

" Color scheme settings
syntax enable
set background=dark

" GitHub Theme settings
lua <<EOF
require('github-theme').setup({
  options = {
    transparent = false,
    hide_nc_statusline = false,
    dim_inactive = false,
    styles = {
      functions = "italic",
    },
    darken = {
      floats = true,
      sidebars = {
        enable = true,
        list = {"qf", "vista_kind", "terminal", "spectre_panel", "NeogitStatus", "Outline"},
      },
    },
  },
  on_colors = function(colors)
    colors.hint = colors.orange
    colors.error = colors.red
  end,
  on_highlights = function(hl, c)
    local prompt = "#2d3149"
    hl.TelescopeNormal = {
      bg = c.bg_dark,
      fg = c.fg_dark,
    }
    hl.TelescopeBorder = {
      bg = c.bg_dark,
      fg = c.bg_dark,
    }
    hl.TelescopeSelectionCaret = {
      fg = prompt,
      bg = prompt,
    }
    hl.TelescopeSelection = {
      fg = prompt,
      bg = prompt,
    }
    hl.TelescopeMatching = {
      fg = c.blue7,
    }
  end,
})

-- Set the colorscheme
vim.cmd('colorscheme github_dark')
EOF

lua <<EOF
---------------------------------------------------------------------
-- Add our custom treesitter parsers
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()

---------------------------------------------------------------------
-- Add our treesitter textobjects
require'nvim-treesitter.configs'.setup {
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },

    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },
}

require("conform").setup({
  formatters_by_ft = {
    cpp = { "clang_format" },
  },

  format_on_save = {
    lsp_fallback = true,
  },
})

---------------------------------------------------------------------
-- Gitsigns

require('gitsigns').setup()

---------------------------------------------------------------------

---------------------------------------------------------------------
-- Add our go conf
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_command([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
    ]])
    local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    vim.api.nvim_create_autocmd({ "CursorHold" }, {
      group = group,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.document_highlight()
      end,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved" }, {
      group = group,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.clear_references()
      end,
    })
  end
end
  nvim_lsp["gopls"].setup { on_attach = on_attach }
  nvim_lsp["zls"].setup {
    on_attach = on_attach,
    settings = {
      zls = {
        enable_inlay_hints = true,
        enable_semantic_tokens = true,
        enable_ast_check_diagnostics = true,
        enable_import_embedfile_subcommand = true,
        enable_autofix = true,
        enable_document_symbols = true,
        enable_completion = true,
        enable_go_to_definition = true,
        enable_hover = true,
        enable_references = true,
        enable_rename = true,
        enable_signature_help = true,
        enable_snippets = true,
        enable_type_information = true,
        enable_workspace_symbols = true,
        enable_format = true,
        enable_incremental_sync = true,
        enable_std_references = true,
        enable_std_symbols = true,
        enable_std_completion = true,
        enable_std_go_to_definition = true,
        enable_std_hover = true,
        enable_std_references = true,
        enable_std_rename = true,
        enable_std_signature_help = true,
        enable_std_snippets = true,
        enable_std_type_information = true,
        enable_std_workspace_symbols = true,
      }
    }
  }

---------------------------------------------------------------------
-- CodeCompanion

require("codecompanion").setup({
  adapters = {
    gemini = function()
      return require("codecompanion.adapters").extend("gemini", {
        env = {
          api_key = "cmd:op read op://Gemini/credential/notesPlain --no-newline",
        },
        schema = {
          model = {
            default = "gemini-2.5-pro-exp-03-25",
          },
        },
      })
    end,
  },
  display = {
    chat = {
      show_header_separator = true,
      -- show_settings = true,
      show_references = true,
      show_token_count = true,
      window = {
        opts = {
          number = false,
          signcolumn = "no",
          language = "Japanese",
        },
      },
    },
  },
  strategies = {
    chat = {
      adapter = "gemini",
      keymaps = {
        completion = {
          modes = { i = "<C-/>" },
          callback = "keymaps.completion",
          description = "Completion Menu",
        },
      },
    },
    inline = {
      adapter = "gemini",
    },
  },
})
vim.keymap.set(
  { "n", "v" },
  "<C-a>",
  "<cmd>CodeCompanionActions<cr>",
  { noremap = true, silent = true }
)
vim.keymap.set(
  { "n" },
  "<C-c>",
  "<cmd>CodeCompanionChat Toggle<cr>",
  { noremap = true, silent = true }
)
vim.keymap.set(
  { "v" },
  "<C-c>",
  "<cmd>CodeCompanionChat Add<cr>",
  { noremap = true, silent = true }
)
EOF
''