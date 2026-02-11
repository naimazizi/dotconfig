if not vim.g.vscode then
  return {}
end

local enabled = {
  "dial.nvim",
  "lazy.nvim",
  "mini.ai",
  "mini.comment",
  "mini.move",
  "mini.pairs",
  "mini.surround",
  "nvim-treesitter",
  "nvim-treesitter-textobjects",
  "nvim-ts-context-commentstring",
  "vim-repeat",
  "yanky.nvim",
}

local Config = require("lazy.core.config")
Config.options.checker.enabled = false
Config.options.change_detection.enabled = false
Config.options.defaults.cond = function(plugin)
  return vim.tbl_contains(enabled, plugin.name) or plugin.vscode
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
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "treesitter", "regex" },
      },
    },
  },
  {
    "danymat/neogen",
    vscode = true,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { highlight = { enable = false } },
  },
}
