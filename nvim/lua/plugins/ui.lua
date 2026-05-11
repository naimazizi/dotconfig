return {
  { "nvim-tree/nvim-web-devicons", vscode = false, opts = {} },
  {
    "petertriho/nvim-scrollbar",
    event = "BufRead",
    vscode = false,
    config = function()
      require("scrollbar").setup()
    end,
  },
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    vscode = false,
    keys = { { "<leader>cs", "<cmd>Outline<cr>", desc = "Toggle Outline" } },
    opts = {
      outline_window = { position = "right", auto_jump = true, wrap = false },
      keymaps = {
        down_and_jump = {},
        up_and_jump = {},
      },
    },
  },
  {
    "shortcuts/no-neck-pain.nvim",
    event = "VeryLazy",
    version = "*",
    keys = {
      { "<leader>uz", "<cmd>NoNeckPain<cr>", desc = "Toggle zen-mode" },
    },
  },
  {
    "TheNoeTrevino/haunt.nvim",
    vscode = false,
    event = "BufReadPost",
    opts = {
      sign = "󱙝",
      sign_hl = "DiagnosticInfo",
      virt_text_hl = "HauntAnnotation",
      annotation_prefix = " 󰆉 ",
      line_hl = nil,
      virt_text_pos = "eol",
      data_dir = nil,
      picker_keys = {
        delete = { key = "d", mode = { "n" } },
        edit_annotation = { key = "a", mode = { "n" } },
      },
    },
    -- recommended keymaps, with a helpful prefix alias
    init = function()
      local haunt = require("haunt.api")
      local haunt_picker = require("haunt.picker")
      local map = vim.keymap.set
      local prefix = "<leader>h"

      -- annotations
      map("n", prefix .. "a", function()
        haunt.annotate()
      end, { desc = "Annotate" })

      map("n", prefix .. "t", function()
        haunt.toggle_annotation()
      end, { desc = "Toggle annotation" })

      map("n", prefix .. "T", function()
        haunt.toggle_all_lines()
      end, { desc = "Toggle all annotations" })

      map("n", prefix .. "d", function()
        haunt.delete()
      end, { desc = "Delete bookmark" })

      map("n", prefix .. "C", function()
        haunt.clear_all()
      end, { desc = "Delete all bookmarks" })

      -- quickfix
      map("n", prefix .. "q", function()
        haunt.to_quickfix()
      end, { desc = "Send Hauntings to QF Lix (buffer)" })

      map("n", prefix .. "Q", function()
        haunt.to_quickfix({ current_buffer = true })
      end, { desc = "Send Hauntings to QF Lix (all)" })

      -- yank
      map("n", prefix .. "y", function()
        haunt.yank_locations({ current_buffer = true })
      end, { desc = "Send Hauntings to Clipboard (buffer)" })

      map("n", prefix .. "Y", function()
        haunt.yank_locations()
      end, { desc = "Send Hauntings to Clipboard (all)" })

      -- move
      map("n", prefix .. "p", function()
        haunt.prev()
      end, { desc = "Previous bookmark" })

      map("n", prefix .. "n", function()
        haunt.next()
      end, { desc = "Next bookmark" })

      -- picker
      map("n", prefix .. "h", function()
        haunt_picker.show({ layout = require("utils.pick").layout })
      end, { desc = "Show Picker" })
    end,
  },
}
