return {
  -- -- Disable avante in favor of copilot.lua + codecompanion.nvim
  -- {
  --   "yetone/avante.nvim",
  --   vscode = false,
  --   event = "VeryLazy",
  --   version = false,
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     "folke/which-key.nvim",
  --     "folke/snacks.nvim",
  --     "zbirenbaum/copilot.lua",
  --     {
  --       "MeanderingProgrammer/render-markdown.nvim",
  --       vscode = false,
  --       ft = function(_, ft)
  --         vim.list_extend(ft, { "Avante" })
  --       end,
  --       opts = function(_, opts)
  --         opts.file_types = vim.list_extend(opts.file_types or {}, { "Avante" })
  --       end,
  --     },
  --   },
  --   opts = {
  --     mode = "agentic",
  --     -- Default configuration
  --     hints = { enabled = true },
  --
  --     ---@alias AvanteProvider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
  --     provider = "copilot", -- Recommend using Claude
  --     auto_suggestions_provider = "copilot", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
  --
  --     -- File selector configuration
  --     --- @alias FileSelectorProvider "native" | "fzf" | "mini.pick" | "snacks" | "telescope" | string
  --     file_selector = {
  --       provider = "snacks", -- Avoid native provider issues
  --       provider_opts = {
  --         -- Additional snacks.input options
  --         title = "Avante Input",
  --         icon = " ",
  --       },
  --     },
  --     windows = {
  --       position = "left",
  --     },
  --   },
  --   config = function(_, opts)
  --     require("avante").setup(opts)
  --     require("which-key").add({ "<leader>a", group = "avante (ai)" })
  --   end,
  --   build = "make",
  -- },
  {
    "copilotlsp-nvim/copilot-lsp",
    vscode = false,
    event = "InsertEnter",
  },
  {
    "zbirenbaum/copilot.lua",
    requires = {
      "copilotlsp-nvim/copilot-lsp",
      init = function()
        vim.g.copilot_nes_debounce = 500
      end,
    },
    vscode = false,
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = not vim.g.ai_cmp,
        auto_trigger = true,
        hide_during_completion = vim.g.ai_cmp,
        keymap = {
          accept = false, -- handled by nvim-cmp / blink.cmp
          next = "<M-]>",
          prev = "<M-[>",
        },
      },
      panel = { enabled = false },
      server = {
        type = "binary", -- "nodejs" | "binary"
      },
      nes = {
        enabled = true,
        keymap = {
          accept_and_goto = "<Tab>",
          accept = false,
          dismiss = "<Esc>",
        },
      },
    },
  },
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    vscode = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "codecompanion" },
      },
    },
    config = function()
      ---@diagnostic disable-next-line: need-check-nil
      require("codecompanion").setup({
        memory = {
          opts = {
            chat = {
              enabled = true,
            },
          },
        },
        strategies = {
          chat = {
            adapter = "copilot",
          },
          inline = {
            adapter = "copilot",
          },
          cmd = {
            adapter = "copilot",
          },
        },
        display = {
          action_palette = {
            width = 95,
            height = 5,
            prompt = "Prompt ",
            provider = "snacks",
            opts = {
              show_default_actions = true, -- Show the default actions in the action palette?
              show_default_prompt_library = true, -- Show the default prompt library in the action palette?
              title = "CodeCompanion actions", -- The title of the action palette
            },
          },
        },
      })

      require("which-key").add({
        { "<leader>a", desc = "+ai", icon = " " },
      })

      vim.keymap.set({ "n", "v" }, "<leader>at", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
      vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
      vim.keymap.set("v", "<leader>ad", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
      vim.cmd([[cab cc CodeCompanion]])
    end,
  },
}
