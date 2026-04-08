if not vim.g.vscode then
  return {}
end

local Config = require("lazy.core.config")
Config.options.checker.enabled = false
Config.options.change_detection.enabled = false
Config.options.defaults.cond = function(plugin)
  return plugin.vscode
end

return {
  {
    "vscode-neovim/vscode-multi-cursor.nvim",
    event = "VeryLazy",
    vscode = true,
    opts = {
      -- Whether to set default mappings
      default_mappings = true,
      -- If set to true, only multiple cursors will be created without multiple selections
      no_selection = false,
    },
  },
  {
    "RRethy/vim-illuminate",
    vscode = true,
    opts = {
      delay = 100,
      providers = {
        "treesitter",
        "regex",
      },
      under_cursor = false,
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    vscode = true,
    opts = { highlight = { enable = false } },
  },
  {
    "saghen/blink.pairs",
    vscode = true,
    event = "BufRead",
    version = "*",
    dependencies = "saghen/blink.download",
    --- @module 'blink.pairs'
    --- @type blink.pairs.Config
    opts = {
      mappings = {
        enabled = true,
        cmdline = true,
        disabled_filetypes = {},
        pairs = {},
      },
      highlights = {
        enabled = false,
        cmdline = false,
      },
      debug = false,
    },
  },
}
