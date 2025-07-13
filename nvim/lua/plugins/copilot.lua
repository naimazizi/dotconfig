return {
  {
    "copilotlsp-nvim/copilot-lsp",
    event = "BufRead",
    cond = function()
      return vim.g.copilot_nes_enabled ~= false
    end,
    vscode = false,
    init = function()
      vim.g.copilot_nes_debounce = 500
      vim.lsp.enable("copilot_ls")

      vim.keymap.set("n", "<tab>", function()
        -- Try to jump to the start of the suggestion edit.
        -- If already at the start, then apply the pending suggestion and jump to the end of the edit.
        local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
          or (require("copilot-lsp.nes").apply_pending_nes() and require("copilot-lsp.nes").walk_cursor_end_edit())
      end)

      -- Clear search and stop snippet on escape
      vim.keymap.set({ "i", "n", "s" }, "<esc>", function()
        if not require("copilot-lsp.nes").clear() then
          vim.cmd("noh")
          LazyVim.cmp.actions.snippet_stop()
        end
        return "<esc>"
      end, { expr = true, desc = "Escape and Clear hlsearch" })
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    cond = function()
      return vim.g.copilot_nes_enabled ~= true
    end,
    vscode = false,
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
}
