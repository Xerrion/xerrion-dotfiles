return {
  -- Filetype detection
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.filetype.add({ extension = { wgsl = "wgsl" } })
    end,
  },

  -- Tree-sitter parser
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "wgsl",
      },
    },
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        wgsl_analyzer = {},
      },
    },
  },

  -- Mason auto-install
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "wgsl-analyzer",
      },
    },
  },

  -- Formatter - defer to LSP (wgsl-analyzer provides formatting)
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        wgsl = {},
      },
    },
  },
}
