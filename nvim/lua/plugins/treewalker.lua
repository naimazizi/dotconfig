return {
  {
    "aaronik/treewalker.nvim",
    event = "VeryLazy",
    vscode = true,
    opts = {
      -- Whether to briefly highlight the node after jumping to it
      highlight = true,

      -- How long should above highlight last (in ms)
      highlight_duration = 250,

      -- The color of the above highlight. Must be a valid vim highlight group.
      -- (see :h highlight-group for options)
      highlight_group = "CursorLine",
    },
    keys = {
      -- movement
      { "<localleader>{", "<cmd>Treewalker Up<cr>", mode = { "n", "v" }, desc = "Treewalker Up" },
      { "<localleader>}", "<cmd>Treewalker Down<cr>", mode = { "n", "v" }, desc = "Treewalker Down" },
      { "<localleader>[", "<cmd>Treewalker Left<cr>", mode = { "n", "v" }, desc = "Treewalker Left" },
      { "<localleader>]", "<cmd>Treewalker Right<cr>", mode = { "n", "v" }, desc = "Treewalker Right" },
    },
  },
}
