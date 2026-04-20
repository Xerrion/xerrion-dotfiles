return {
  -- Catppuccin (default)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {},
  },

  -- Nord (alternative)
  {
    "gbprod/nord.nvim",
    lazy = true,
    opts = {},
  },

  -- Set default colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
