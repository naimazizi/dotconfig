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
      -- close window
      ["q"] = function(win)
        win:close()
      end,
      -- hide window
      ["<c-q>"] = function(win)
        win:hide()
      end,
      -- close sidebar
      ["Q"] = function(win)
        win.view.edgebar:close()
      end,
    },
    config = function(_, opts)
      opts = {
        animate = {
          enabled = false,
        },
        options = {
          left = { size = 0.15 },
          bottom = { size = 0.15 },
          right = { size = 0.30 },
        },
        bottom = {
          { title = "Neotest Output", ft = "neotest-output-panel" },
          { ft = "trouble", title = "Trouble" },
          {
            ft = "noice",
            filter = function(_buf, win)
              return vim.api.nvim_win_get_config(win).relative == ""
            end,
          },
          {
            ft = "help",
            -- don't open help files in edgy that we're editing
            filter = function(buf)
              return vim.bo[buf].buftype == "help"
            end,
          },
          {
            title = "Overseer Output",
            ft = "OverseerOutput",
          },
          {
            title = "DAP",
            ft = "dap-view",
          },
          {
            title = "DAP",
            ft = "dap-repl",
          },

          {
            title = "DAP Term",
            ft = "dap-view-term",
          },
          {
            title = "DB Query Result",
            ft = "dbout",
          },
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
        },
        left = {
          {
            title = "Explorer",
            ft = "neo-tree",
            size = { height = 0.4 },
            pinned = true,
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
            pinned = true,
            open = "Outline",
          },
        },
        right = {
          { title = "Grug Far", ft = "grug-far", size = { height = 0.50 } },
          {
            title = "Overseer",
            ft = "OverseerList",
            open = function()
              require("overseer").open()
            end,
            size = { height = 0.4 },
          },
          { title = "Neotest Summary", ft = "neotest-summary" },
        },
      }
      require("edgy").setup(opts)
      return opts
    end,
  },
  {
    "folke/snacks.nvim",
    keys = {
      { "<C-/>", "<cmd>lua Snacks.terminal.toggle()<CR>", desc = "Toggle terminal" },
      { "<leader>ft", "<cmd>lua Snacks.terminal()<CR>", desc = "Toggle terminal" },
      {
        "<leader>gg",
        function()
          Snacks.lazygit()
        end,
        desc = "Lazygit",
      },
      {
        "<leader>gB",
        function()
          Snacks.gitbrowse()
        end,
        desc = "Browse",
      },
      {
        "<leader>gi",
        function()
          Snacks.picker.gh_issue()
        end,
        desc = "GitHub Issues (open)",
      },
      {
        "<leader>gI",
        function()
          Snacks.picker.gh_issue({ state = "all" })
        end,
        desc = "GitHub Issues (all)",
      },
      {
        "<leader>gp",
        function()
          Snacks.picker.gh_pr()
        end,
        desc = "GitHub Pull Requests (open)",
      },
      {
        "<leader>gP",
        function()
          Snacks.picker.gh_pr({ state = "all" })
        end,
        desc = "GitHub Pull Requests (all)",
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
      outline_window = { position = "left", auto_jump = true, wrap = false },
      keymaps = {
        down_and_jump = {},
        up_and_jump = {},
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    vscode = false,
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      {
        "]h",
        function()
          require("gitsigns").next_hunk()
        end,
        desc = "Next hunk",
      },
      {
        "[h",
        function()
          require("gitsigns").prev_hunk()
        end,
        desc = "Prev hunk",
      },
      {
        "<leader>gs",
        function()
          require("gitsigns").stage_hunk()
        end,
        mode = { "n", "v" },
        desc = "Stage hunk",
      },
      {
        "<leader>gr",
        function()
          require("gitsigns").reset_hunk()
        end,
        mode = { "n", "v" },
        desc = "Reset hunk",
      },
      {
        "<leader>gS",
        function()
          require("gitsigns").stage_buffer()
        end,
        desc = "Stage buffer",
      },
      {
        "<leader>gR",
        function()
          require("gitsigns").reset_buffer()
        end,
        desc = "Reset buffer",
      },
      {
        "<leader>gv",
        function()
          require("gitsigns").preview_hunk()
        end,
        desc = "Preview hunk",
      },
      {
        "<leader>gb",
        function()
          require("gitsigns").toggle_current_line_blame()
        end,
        desc = "Toggle line blame",
      },
    },
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text_pos = "right_align",
        delay = 500,
      },
    },
  },
  {
    "Fildo7525/pretty_hover",
    event = "LspAttach",
    opts = {},
  },
  {
    "patrickpichler/hovercraft.nvim",
    event = "BufReadPre",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    -- this is the default config and can be skipped
    opts = function()
      return {
        providers = {
          providers = {
            {
              "LSP",
              require("hovercraft.provider.lsp.hover").new(),
            },
            {
              "Man",
              require("hovercraft.provider.man").new(),
            },
            {
              "Dictionary",
              require("hovercraft.provider.dictionary").new(),
            },
          },
        },
        window = {
          border = "single",
          padding = {
            left = 0,
            right = 0,
          },
          -- enable this if you are a user of the MeanderingProgrammer/render-markdown.nvim plugin
          render_markdown_compat_mode = true,
        },
        keys = {
          {
            "<C-u>",
            function()
              require("hovercraft").scroll({ delta = -4 })
            end,
          },
          {
            "<C-d>",
            function()
              require("hovercraft").scroll({ delta = 4 })
            end,
          },
          {
            "<TAB>",
            function()
              require("hovercraft").hover_next()
            end,
          },
          {
            "<S-TAB>",
            function()
              require("hovercraft").hover_next({ step = -1 })
            end,
          },
        },
      }
    end,
    keys = {
      {
        "K",
        function()
          local hovercraft = require("hovercraft")
          if hovercraft.is_visible() then
            hovercraft.enter_popup()
          else
            hovercraft.hover()
          end
        end,
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
    ---@class HauntConfig
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

      -- move
      map("n", prefix .. "p", function()
        haunt.prev()
      end, { desc = "Previous bookmark" })

      map("n", prefix .. "n", function()
        haunt.next()
      end, { desc = "Next bookmark" })

      -- picker
      map("n", prefix .. "l", function()
        haunt_picker.show()
      end, { desc = "Show Picker" })
    end,
  },
  {
    "romgrk/barbar.nvim",
    vscode = false,
    event = "VimEnter",
    dependencies = {
      "lewis6991/gitsigns.nvim",
    },
    keys = {
      { "<S-h>", "<cmd>BufferPrevious<cr>", desc = "Prev buffer" },
      { "<S-l>", "<cmd>BufferNext<cr>", desc = "Next buffer" },
      { "<leader>bd", "<cmd>BufferClose<cr>", desc = "Delete buffer" },
      { "<leader>bD", "<cmd>BufferPickDelete<cr>", desc = "Delete buffer (pick)" },
      { "<leader>bo", "<cmd>BufferCloseAllButCurrent<cr>", desc = "Delete other buffers" },
      { "<leader>bh", "<cmd>BufferCloseBuffersLeft<cr>", desc = "Delete buffers to the left" },
      { "<leader>bl", "<cmd>BufferCloseBuffersRight<cr>", desc = "Delete buffers to the right" },
      { "<leader>bB", "<cmd>BufferPick<cr>", desc = "Pick Buffer" },
      { "<leader>bp", "<cmd>BufferPin<cr>", desc = "Pin Buffer" },
      { "<leader>bP", "<cmd>BufferCloseAllButPinned<cr>", desc = "Delete unpinned buffers" },
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {
      insert_at_start = true,
      icons = {
        pinned = { button = "", filename = true },
      },
      sidebar_filetypes = {
        ["neo-tree"] = true,
      },
    },
  },
  {
    "yorickpeterse/nvim-window",
    vscode = false,
    event = "VeryLazy",
    keys = {
      { "<leader>w", "<cmd>lua require('nvim-window').pick()<cr>", desc = "Window Selection" },
    },
    config = true,
  },
}
