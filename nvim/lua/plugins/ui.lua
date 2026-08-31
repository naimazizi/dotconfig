return {
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    vscode = false,
    keys = {
      {
        "<leader>uE",
        function()
          require("edgy").toggle()
        end,
        desc = "Edgy Toggle",
      },
      {
        "<A-w>",
        function()
          require("edgy").select()
        end,
        desc = "Edgy Select Window",
      },
    },
    opts = {
      animate = { enabled = false },
      options = {
        left = { size = 0.20 },
        bottom = { size = 0.15 },
        right = { size = 0.30 },
      },
      keys = {
        -- increase width
        ["<c-Right>"] = function(win)
          win:resize("width", 2)
        end,
        -- decrease width
        ["<c-Left>"] = function(win)
          win:resize("width", -2)
        end,
        -- increase height
        ["<c-Up>"] = function(win)
          win:resize("height", 2)
        end,
        -- decrease height
        ["<c-Down>"] = function(win)
          win:resize("height", -2)
        end,
      },
      bottom = {
        { title = "Neotest Output", ft = "neotest-output-panel" },
        { title = "Overseer Output", ft = "OverseerOutput" },
        { title = "DAP", ft = "dap-view" },
        { title = "DAP", ft = "dap-repl" },
        { title = "DAP Term", ft = "dap-view-term" },
        {
          title = "Terminal",
          ft = "snacks_terminal",
          pinned = true,
          open = function()
            Snacks.terminal()
          end,
          filter = function(_, win)
            return vim.api.nvim_win_get_config(win).relative == ""
          end,
        },
        {
          title = "Quickfix",
          ft = "qf",
        },
      },
      left = {
        {
          title = "Explorer",
          ft = "neo-tree",
          size = { height = 0.4 },
          pinned = false,
          open = function()
            require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
          end,
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "filesystem"
          end,
        },
        {
          title = "Outline",
          ft = "Outline",
          pinned = false,
          open = "Outline",
          size = { height = 0.50 },
        },
        {
          title = "Overseer",
          ft = "OverseerList",
          open = function()
            require("overseer").open()
          end,
          size = { height = 0.4 },
        },
        { title = "Neotest Summary", ft = "neotest-summary" },
        {
          title = "Help",
          ft = "help",
          filter = function(buf)
            return vim.bo[buf].buftype == "help"
          end,
        },
      },
      right = {
        { title = "Grug Far", ft = "grug-far", size = { width = 0.30 } },
      },
    },
  },
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
    opts = {},
  },
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    vscode = false,
    keys = { { "<leader>cs", "<cmd>Outline<cr>", desc = "Toggle Outline" } },
    opts = {
      outline_window = { position = "left", auto_jump = true, wrap = false },
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
        require("haunt.picker").show()
      end, { desc = "Show Picker" })
    end,
  },
}
