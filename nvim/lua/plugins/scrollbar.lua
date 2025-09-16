return {
  {
    "petertriho/nvim-scrollbar",
    event = "VeryLazy",
    cond = not vim.g.vscode,
    config = function()
      require("scrollbar").setup()
    end,
  },
}
