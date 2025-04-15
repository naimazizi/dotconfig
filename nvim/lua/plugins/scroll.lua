return {
  {
    "petertriho/nvim-scrollbar",
    event = "BufEnter",
    config = function()
      require("scrollbar").setup({})
    end,
  },
}
