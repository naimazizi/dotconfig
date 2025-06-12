return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    vscode = false,
    opts = {
      spec = {
        { "<localleader>r", group = "+REPL" },
        { "<localleader>m", group = "+Molten (Inline REPL)" },
        { "<localleader>s", group = "+Slime Repl" },
        { "<localleader>e", group = "+Ecolog (.env)" },
      },
    },
  },
}
