return {
  {
    "max397574/better-escape.nvim",
    vscode = false,
    event = "VeryLazy",
    config = function()
      require("better_escape").setup({
        timeout = 100, -- time in milliseconds to wait for a second key press
      })
    end,
  },
}
