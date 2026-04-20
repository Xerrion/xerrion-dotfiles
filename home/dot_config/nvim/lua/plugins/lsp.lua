return {
  -- Additional treesitter parsers beyond what extras provide
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "html",
        "css",
        "bash",
        "regex",
        "query",
        "vim",
        "vimdoc",
      },
    },
  },
}
