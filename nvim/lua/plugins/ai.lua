return {
  {
    "sudo-tee/opencode.nvim",
    event = "VeryLazy",
    vscode = false,
    cmd = "Opencode",
    config = function()
      require("opencode").setup({
        preferred_picker = "fzf", -- 'telescope', 'fzf', 'mini.pick', 'snacks', 'select', if nil, it will use the best available picker. Note mini.pick does not support multiple selections
        preferred_completion = "blink",
        default_global_keymaps = true,
        default_mode = "build",
        keymap_prefix = "<leader>a",
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MeanderingProgrammer/render-markdown.nvim",
      "saghen/blink.cmp",
      "ibhagwan/fzf-lua",
    },
  },
  {
    "copilotlsp-nvim/copilot-lsp",
    event = "VeryLazy",
    vscode = false,
    init = function()
      vim.g.copilot_nes_debounce = 500
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
      vim.keymap.set("n", "<esc>", function()
        if not require("copilot-lsp.nes").clear() then
          -- fallback to other functionality
          vim.cmd("noh")
          LazyVim.cmp.actions.snippet_stop()
          return "<esc>"
        end
      end, { desc = "Clear Copilot suggestion or fallback" })
    end,
  },
}
