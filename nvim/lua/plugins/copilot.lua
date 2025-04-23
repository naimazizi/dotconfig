return {
  {
    "copilotlsp-nvim/copilot-lsp",
    enabled = false, -- waiting for inline completion support
    event = "BufRead",
    init = function()
      vim.g.copilot_nes_debounce = 500
      vim.lsp.enable("copilot")
      vim.keymap.set("n", "<tab>", function()
        require("copilot-lsp.nes").apply_pending_nes()
      end)
    end,
  },
  {
    "giuxtaposition/blink-cmp-copilot",
    enabled = false, -- disabled in favor of fang2hou/blink-copilot
  },
}
