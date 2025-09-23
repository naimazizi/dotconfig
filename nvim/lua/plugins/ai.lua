return {
  -- -- Disable avante in favor of copilot.lua + opencode.nvim
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
    "NickvanDyke/opencode.nvim",
    event = "VeryLazy",
    dependencies = {
      { "folke/snacks.nvim", opts = { input = { enabled = true } } },
    },
    config = function()
      vim.g.opencode_opts = {
        -- Your configuration, if any — see `lua/opencode/config.lua`
      }
      -- Required for `opts.auto_reload`
      vim.opt.autoread = true
      -- Recommended keymaps
      vim.keymap.set("n", "<leader>at", function()
        require("opencode").toggle()
      end, { desc = "Toggle Window" })
      vim.keymap.set("n", "<leader>aA", function()
        require("opencode").ask()
      end, { desc = "Ask" })
      vim.keymap.set("n", "<leader>aa", function()
        require("opencode").ask("@cursor: ")
      end, { desc = "Ask about this" })
      vim.keymap.set("v", "<leader>aa", function()
        require("opencode").ask("@selection: ")
      end, { desc = "Ask about selection" })
      vim.keymap.set("n", "<leader>a+", function()
        require("opencode").append_prompt("@buffer")
      end, { desc = "Add buffer to prompt" })
      vim.keymap.set("v", "<leader>a+", function()
        require("opencode").append_prompt("@selection")
      end, { desc = "Add selection to prompt" })
      vim.keymap.set("n", "<leader>an", function()
        require("opencode").command("session_new")
      end, { desc = "New session" })
      vim.keymap.set("n", "<leader>ay", function()
        require("opencode").command("messages_copy")
      end, { desc = "Copy last response" })
      vim.keymap.set("n", "<S-C-u>", function()
        require("opencode").command("messages_half_page_up")
      end, { desc = "Messages half page up" })
      vim.keymap.set("n", "<S-C-d>", function()
        require("opencode").command("messages_half_page_down")
      end, { desc = "Messages half page down" })
      vim.keymap.set({ "n", "v" }, "<leader>as", function()
        require("opencode").select()
      end, { desc = "Select prompt" })

      -- Example: keymap for custom prompt
      vim.keymap.set("n", "<leader>ae", function()
        require("opencode").prompt("Explain @cursor and its context")
      end, { desc = "Explain this code" })

      require("which-key").add({ "<leader>a", group = "opencode (AI)", icon = " " })
    end,
  },
}
