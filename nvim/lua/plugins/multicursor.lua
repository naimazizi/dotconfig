return {
  {
    "brenton-leighton/multiple-cursors.nvim",
    version = "*", -- Use the latest tagged version
    opts = {}, -- This causes the plugin setup function to be called
    keys = {
      { "<C-j>", "<Cmd>MultipleCursorsAddDown<CR>", mode = { "n", "x" }, desc = "Add cursor and move down" },
      { "<C-k>", "<Cmd>MultipleCursorsAddUp<CR>", mode = { "n", "x" }, desc = "Add cursor and move up" },

      { "<C-Up>", "<Cmd>MultipleCursorsAddUp<CR>", mode = { "n", "i", "x" }, desc = "Add cursor and move up" },
      { "<C-Down>", "<Cmd>MultipleCursorsAddDown<CR>", mode = { "n", "i", "x" }, desc = "Add cursor and move down" },

      { "<C-LeftMouse>", "<Cmd>MultipleCursorsMouseAddDelete<CR>", mode = { "n", "i" }, desc = "Add or remove cursor" },

      { "<localleader>N", "<Cmd>MultipleCursorsAddMatches<CR>", mode = { "n", "x" }, desc = "Add cursors to cword" },
      -- {
      --   "<Leader>N",
      --   "<Cmd>MultipleCursorsAddMatchesV<CR>",
      --   mode = { "n", "x" },
      --   desc = "Add cursors to cword in previous area",
      -- },

      {
        "<localleader>n",
        "<Cmd>MultipleCursorsAddJumpNextMatch<CR>",
        mode = { "n", "x" },
        desc = "Add cursor and jump to next cword",
      },
      -- { "<Leader>N", "<Cmd>MultipleCursorsJumpNextMatch<CR>", mode = { "n", "x" }, desc = "Jump to next cword" },

      { "<localleader>l", "<Cmd>MultipleCursorsLock<CR>", mode = { "n", "x" }, desc = "Lock virtual cursors" },
    },
  },
}
