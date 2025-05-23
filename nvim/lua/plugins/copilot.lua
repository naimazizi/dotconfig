return {
  {
    "copilotlsp-nvim/copilot-lsp",
    event = "BufRead",
    init = function()
      vim.g.copilot_nes_debounce = 500
      vim.lsp.enable("copilot")
    end,
  },
  {
    "giuxtaposition/blink-cmp-copilot",
    enabled = false, -- disabled in favor of fang2hou/blink-copilot
  },
}
