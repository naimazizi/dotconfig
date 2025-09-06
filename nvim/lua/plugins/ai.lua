return {
  {
    "yetone/avante.nvim",
    cond = not vim.g.vscode,
    event = "VeryLazy",
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
    },
    config = function(_, opts)
      require("avante").setup(opts)
      require("which-key").add({ "<leader>a", group = "avante (ai)" })
    end,
    build = "make",
  },
  {
    "zbirenbaum/copilot.lua",
    cond = not vim.g.vscode,
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = not vim.g.ai_cmp,
        auto_trigger = true,
        hide_during_completion = vim.g.ai_cmp,
        keymap = {
          accept = false, -- handled by nvim-cmp / blink.cmp
        },
      },
      panel = { enabled = false },
    },
  },
  {
    "copilotlsp-nvim/copilot-lsp",
    event = "InsertEnter",
    cond = not vim.g.vscode,
    config = function()
      ---@diagnostic disable-next-line: param-type-not-match, missing-parameter
      require("copilot-lsp").setup({
        nes = {
          move_count_threshold = 2,
          distance_threshold = 10,
          clear_on_large_distance = true,
          count_horizontal_moves = true,
          reset_on_approaching = true,
        },
      })
      vim.g.copilot_nes_debounce = 250
      vim.lsp.enable("copilot_ls")

      vim.keymap.set("n", "<tab>", function()
        local bufnr = vim.api.nvim_get_current_buf()
        local state = vim.b[bufnr].nes_state
        if state then
          -- Try to jump to the start of the suggestion edit.
          -- If already at the start, then apply the pending suggestion and jump to the end of the edit.
          local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
            or (require("copilot-lsp.nes").apply_pending_nes() and require("copilot-lsp.nes").walk_cursor_end_edit())
          return nil
        else
          -- Resolving the terminal's inability to distinguish between `TAB` and `<C-i>` in normal mode
          return "<C-i>"
        end
      end, { desc = "Accept Copilot NES suggestion", expr = true })

      -- Clear copilot suggestion with Esc if visible, otherwise preserve default Esc behavior
      vim.keymap.set("n", "<esc>", function()
        if not require("copilot-lsp.nes").clear() then
        end

        vim.cmd("nohlsearch")
      end, { desc = "Clear Copilot suggestion or fallback" })
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    cond = not vim.g.vscode,
    ft = function(_, ft)
      vim.list_extend(ft, { "Avante" })
    end,
    opts = function(_, opts)
      opts.file_types = vim.list_extend(opts.file_types or {}, { "Avante" })
    end,
  },
}
