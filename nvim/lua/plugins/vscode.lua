-- Configurations when using vscode-neovim.
-- Modified from https://github.com/LazyVim/LazyVim/raw/main/lua/lazyvim/plugins/extras/vscode.lua

if not vim.g.vscode then
  return {}
end

local enabled = {
  "lazy.nvim",
  "flit.nvim",
  "leap.nvim",
  "mini.ai",
  "mini.comment",
  "mini.pairs",
  "mini.surround",
  "nvim-treesitter",
  "nvim-treesitter-textobjects",
  "nvim-ts-context-commentstring",
  "nvim-ts-rainbow2", -- not used but required for loading treesitter
  "vim-repeat",
  "dial.nvim",
  "LazyVim",
}

local Config = require("lazy.core.config")
Config.options.checker.enabled = false
Config.options.change_detection.enabled = false

return {
  {
    "LazyVim/LazyVim",
    config = function(_, opts)
      opts = opts or {}
      -- disable the colorscheme
      opts.colorscheme = function() end
      require("lazyvim").setup(opts)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { highlight = { enable = false }, rainbow = { enable = false } },
  },
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
}
