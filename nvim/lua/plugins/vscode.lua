if not vim.g.vscode then
  return {}
end

local enabled = {
  "lazy.nvim",
  "mini.ai",
  "mini.comment",
  "mini.move",
  "mini.surround",
  "nvim-treesitter",
  "nvim-treesitter-textobjects",
}

local Config = require("lazy.core.config")
Config.options.checker.enabled = false
Config.options.change_detection.enabled = false
Config.options.defaults.cond = function(plugin)
  return vim.tbl_contains(enabled, plugin.name) or plugin.vscode
end
vim.g.snacks_animate = false

return {
  {
    "nvim-treesitter/nvim-treesitter",
    vscode = true,
    lazy = false,
    event = nil,
    opts = { highlight = { enable = false } },
  },
}
