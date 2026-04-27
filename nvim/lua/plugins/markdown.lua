return {
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    dependencies = { "saghen/blink.cmp" },
    config = function()
      local presets = require("markview.presets").block_quotes

      require("markview").setup({
        markdown = {
          block_quotes = presets.obsidian,
          enable = true,
        },
        preview = {
          modes = { "n", "no", "c", "i" },
          hybrid_modes = { "i" },
          linewise_hybrid_mode = true,
        },
      })
    end,
  },
}
