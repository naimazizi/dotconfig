return {
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    vscode = false,
    init = function()
      vim.opt.laststatus = 3
      vim.opt.splitkeep = "screen"
    end,
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
          left = { size = 0.2 },
          bottom = { size = 0.2 },
          right = { size = 0.30 },
        },
        bottom = {
          { title = "Neotest Output", ft = "neotest-output-panel" },
          { ft = "trouble", title = "Diagnostics" },
          {
            ft = "noice",
            filter = function(_buf, win)
              return vim.api.nvim_win_get_config(win).relative == ""
            end,
          },
          { ft = "qf", title = "QuickFix" },
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
            title = "Terminal",
            ft = "toggleterm",
filter = function(_buf, win)
              return vim.api.nvim_win_get_config(win).relative == ""
            end,
          },
          {
            title = "DB Query Result",
            ft = "dbout",
          },
        },
        left = {
          {
            title = "Explorer",
            ft = "NvimTree",
            size = { height = 0.4 },
          },
        },
        right = {
          {
            title = "Outline",
            ft = "Outline",
            open = "Outline",
          },
          { title = "Grug Far", ft = "grug-far", size = { height = 0.30 } },
          -- { title = "AI", ft = "sidekick_terminal", size = { height = 0.5 } },
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
    opts = { outline_window = { position = "left", auto_jump = true, wrap = false } },
  },
  {
    "lewis6991/gitsigns.nvim",
    vscode = false,
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text_pos = "right_align",
        delay = 500,
      },
    },
  },
}
