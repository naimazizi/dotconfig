return {
  {
    "aserowy/tmux.nvim",
    event = "VeryLazy",
    cond = not vim.g.vscode,
    config = function()
      return require("tmux").setup()
    end,
  },
}
