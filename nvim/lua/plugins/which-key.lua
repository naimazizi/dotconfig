return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<localleader>r", group = "+REPL" },
        { "<localleader>m", group = "+Molten (Inline REPL)" },
      },
    },
  },
}
