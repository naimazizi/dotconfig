return {
  { "nvim-tree/nvim-web-devicons", vscode = false, opts = {} },
  {
    "folke/noice.nvim",
    vscode = false,
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    keys = {
      { "<leader>n", "<cmd>Noice<cr>", desc = "Notification" },
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      messages = {
        view_search = false,
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
    },
  },
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
    version = "*",
    cmd = "NoNeckPain",
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
    config = function(_, opts)
      require("haunt").setup(opts)
      local map = vim.keymap.set
      local prefix = "<leader>h"

      -- annotations
      map("n", prefix .. "a", function()
        require("haunt.api").annotate()
      end, { desc = "Annotate" })

      map("n", prefix .. "t", function()
        require("haunt.api").toggle_annotation()
      end, { desc = "Toggle annotation" })

      map("n", prefix .. "T", function()
        require("haunt.api").toggle_all_lines()
      end, { desc = "Toggle all annotations" })

      map("n", prefix .. "d", function()
        require("haunt.api").delete()
      end, { desc = "Delete bookmark" })

      map("n", prefix .. "C", function()
        require("haunt.api").clear_all()
      end, { desc = "Delete all bookmarks" })

      -- quickfix
      map("n", prefix .. "q", function()
        require("haunt.api").to_quickfix()
      end, { desc = "Send Hauntings to QF Lix (buffer)" })

      map("n", prefix .. "Q", function()
        require("haunt.api").to_quickfix({ current_buffer = true })
      end, { desc = "Send Hauntings to QF Lix (all)" })

      -- yank
      map("n", prefix .. "y", function()
        require("haunt.api").yank_locations({ current_buffer = true })
      end, { desc = "Send Hauntings to Clipboard (buffer)" })

      map("n", prefix .. "Y", function()
        require("haunt.api").yank_locations()
      end, { desc = "Send Hauntings to Clipboard (all)" })

      -- move
      map("n", prefix .. "p", function()
        require("haunt.api").prev()
      end, { desc = "Previous bookmark" })

      map("n", prefix .. "n", function()
        require("haunt.api").next()
      end, { desc = "Next bookmark" })

      -- picker
      map("n", prefix .. "h", function()
        require("haunt.picker").show({ layout = require("utils.pick").layout })
      end, { desc = "Show Picker" })
    end,
  },
}
