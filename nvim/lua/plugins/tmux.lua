return {
  {
    "aserowy/tmux.nvim",
    event = "VeryLazy",
    vscode = false,
    config = function()
      return require("tmux").setup()
    end,
  },
}
