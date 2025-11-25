return {
  {
    "esmuellert/vscode-diff.nvim",
    vscode = false,
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    keys = {
      { "<leader>gD", "<cmd>CodeDiff<cr>", desc = "Open VSCode Diff View" },
    },
    config = function()
      require("vscode-diff").setup({
        -- Highlight configuration
        highlights = {
          line_insert = "DiffAdd", -- Line-level insertions
          line_delete = "DiffDelete", -- Line-level deletions

          char_insert = nil, -- Character-level insertions (nil = auto-derive)
          char_delete = nil, -- Character-level deletions (nil = auto-derive)

          char_brightness = nil, -- Auto-adjust based on your colorscheme
        },

        -- Diff view behavior
        diff = {
          disable_inlay_hints = true, -- Disable inlay hints in diff windows for cleaner view
          max_computation_time_ms = 5000, -- Maximum time for diff computation (VSCode default)
        },

        -- Keymaps in diff view
        keymaps = {
          view = {
            next_hunk = "].", -- Jump to next change
            prev_hunk = "[.", -- Jump to previous change
            next_file = "]>", -- Next file in explorer mode
            prev_file = "[>", -- Previous file in explorer mode
          },
          explorer = {
            select = "<CR>", -- Open diff for selected file
            hover = "K", -- Show file diff preview
            refresh = "R", -- Refresh git status
          },
        },
      })
    end,
  },
}
