return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<localleader>r", group = "+REPL" },
        { "<localleader>m", group = "+Molten (Inline REPL)" },
        { "<localleader>s", group = "+Iron Repl" },
        { "<localleader>j", group = "+Jupynium" },

        -- Override description for Iron.nvim
        { "<localleader>ss", desc = "Iron - Toggle Repl" },
        { "<localleader>sc", mode = { "n" }, desc = "Iron - Send Motion to Repl" },
        { "<localleader>sc", mode = { "v" }, desc = "Iron - Send Visual to Repl" },
        { "<localleader>sf", desc = "Iron - Send File to Repl" },
        { "<localleader>sl", desc = "Iron - Send Current Line to Repl" },
        { "<localleader>su", desc = "Iron - Send start until cursor to Repl" },
        { "<localleader>sm", desc = "Iron - Send mark to Repl" },
        { "<localleader>sb", desc = "Iron - Send code block to Repl" },
        { "<localleader>sn", desc = "Iron - Send code block and move to Repl" },
        { "<localleader>sq", desc = "Iron - Mark Motion" },
        { "<localleader>sq", desc = "Iron - Mark Visual" },
        { "<localleader>sd", desc = "Iron - Delete Mark" },
        { "<localleader>s<cr>", desc = "Iron - Send new line" },
        { "<localleader>s<localleader>", desc = "Iron - Interrupt Iron Repl" },
        { "<localleader>sq", desc = "Iron - Exit Iron Repl" },
        { "<localleader>sz", desc = "Iron - Clear Iron Repl" },
      },
    },
  },
}
