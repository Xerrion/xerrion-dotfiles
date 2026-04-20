return {
  -- Copilot core - ghost text completions
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      copilot_model = "gpt-5.4",
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<Tab>",
          accept_word = "<C-Right>",
          accept_line = "<C-Down>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        lua = true,
        toc = true,
        xml = true,
        markdown = true,
        ["*"] = true,
      },
    },
  },

  -- CopilotChat - inline chat window
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      "zbirenbaum/copilot.lua",
      "nvim-lua/plenary.nvim",
    },
    cmd = {
      "CopilotChat",
      "CopilotChatToggle",
      "CopilotChatExplain",
      "CopilotChatReview",
      "CopilotChatFix",
      "CopilotChatOptimize",
    },
    keys = {
      { "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Copilot Chat" },
      { "<leader>ce", "<cmd>CopilotChatExplain<cr>", mode = { "n", "v" }, desc = "Copilot Explain" },
      { "<leader>cr", "<cmd>CopilotChatReview<cr>", mode = { "n", "v" }, desc = "Copilot Review" },
      { "<leader>cf", "<cmd>CopilotChatFix<cr>", mode = { "n", "v" }, desc = "Copilot Fix" },
      { "<leader>co", "<cmd>CopilotChatOptimize<cr>", mode = { "n", "v" }, desc = "Copilot Optimize" },
    },
    opts = {
      model = "claude-opus-4.6",
    },
  },

  -- Disable default nvim-cmp copilot source to avoid conflicts with ghost text
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.mapping = vim.tbl_deep_extend("force", opts.mapping or {}, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          local copilot = require("copilot.suggestion")
          if copilot.is_visible() then
            copilot.accept()
          elseif cmp.visible() then
            cmp.confirm({ select = true })
          else
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
  },
}
