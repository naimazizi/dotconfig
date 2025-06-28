return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    vscode = false,
    dependencies = {
      "stevearc/dressing.nvim",
      "zbirenbaum/copilot.lua", -- for providers='copilot'
    },
    opts = {
      mode = "legacy",
      -- Default configuration
      hints = { enabled = true },

      ---@alias AvanteProvider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
      provider = "copilot", -- Recommend using Claude
      auto_suggestions_provider = "copilot", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot

      -- File selector configuration
      --- @alias FileSelectorProvider "native" | "fzf" | "mini.pick" | "snacks" | "telescope" | string
      file_selector = {
        provider = "snacks", -- Avoid native provider issues
        provider_opts = {},
      },
    },
    build = LazyVim.is_win() and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" or "make",
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    optional = true,
    ft = function(_, ft)
      vim.list_extend(ft, { "Avante" })
    end,
    opts = function(_, opts)
      opts.file_types = vim.list_extend(opts.file_types or {}, { "Avante" })
    end,
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>a", group = "ai" },
      },
    },
  },
}
