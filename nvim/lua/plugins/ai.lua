return {
  -- Disable avante in favor of copilot.lua + sidekick.nvim
  {
    "yetone/avante.nvim",
    enabled = false,
    vscode = false,
    event = "VeryLazy",
    version = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "folke/which-key.nvim",
      "folke/snacks.nvim",
      "zbirenbaum/copilot.lua",
      "MeanderingProgrammer/render-markdown.nvim",
    },
    opts = {
      mode = "agentic",
      -- Default configuration
      hints = { enabled = true },

      ---@alias AvanteProvider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
      provider = "copilot", -- Recommend using Claude
      auto_suggestions_provider = "copilot", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot

      -- File selector configuration
      --- @alias FileSelectorProvider "native" | "fzf" | "mini.pick" | "snacks" | "telescope" | string
      file_selector = {
        provider = "snacks", -- Avoid native provider issues
        provider_opts = {
          -- Additional snacks.input options
          title = "Avante Input",
          icon = " ",
        },
      },
      windows = {
        position = "left",
      },
    },
    config = function(_, opts)
      require("avante").setup(opts)
      require("which-key").add({ "<leader>a", group = "avante (ai)" })
    end,
    build = "make",
  },
  {
    "folke/sidekick.nvim",
    vscode = false,
    opts = {
      cli = {
        mux = {
          backend = "tmux",
          enabled = true,
          create = "split", ---@type "terminal"|"window"|"split"
          split = {
            vertical = true, -- vertical or horizontal split
            size = 0.3, -- size of the split (0-1 for percentage)
          },
        },
        prompts = {
          fix_lang = {
            msg = "Make the sentence better and more concise",
          },
          inline_comments = {
            msg = "Add explanatory inline comments to the following code, clarifying complex logic and variable purposes",
          },
          annotate = {
            msg = "Add detailed annotations to the following code, explaining its functionality, purpose, parameter and return value follow google docstring standard if possible",
          },
        },
      },
    },
  },
}
