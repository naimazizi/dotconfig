return {
  {
    "nvim-lualine/lualine.nvim",
    cond = not vim.g.vscode,
    event = "VeryLazy",
    dependencies = {
      "nvim-mini/mini.icons",
      {
        "letieu/harpoon-lualine",
        event = "VeryLazy",
        cond = not vim.g.vscode,
      },
    },
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            "ministarter",
          },
          ignore_focus = {},
          always_divide_middle = true,
          always_show_tabline = true,
          globalstatus = true,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
            refresh_time = 16, -- ~60fps
            events = {
              "WinEnter",
              "BufEnter",
              "BufWritePost",
              "SessionLoadPost",
              "FileChangedShellPost",
              "VimResized",
              "Filetype",
              "CursorMoved",
              "CursorMovedI",
              "ModeChanged",
            },
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            "branch",
            "diagnostics",
            {
              "diff",
              symbols = {
                added = " ",
                modified = " ",
                removed = " ",
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
          },
          lualine_c = { { "filename", path = 1, file_status = true } },
          lualine_x = {
            "overseer",
            "venv-selector",
            "encoding",
            "fileformat",
            "filetype",
            {
              function()
                return "  " .. require("dap").status()
              end,
              cond = function()
                return package.loaded["dap"] and require("dap").status() ~= ""
              end,
              color = function()
                return { fg = Snacks.util.color("Debug") }
              end,
            },
          },
          lualine_y = {
            { require("recorder").displaySlots },
            { "harpoon2" },
          },
          lualine_z = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {
          "avante",
          "overseer",
          "trouble",
          "lazy",
          "mason",
        },
      })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    cond = not vim.g.vscode,
    dependencies = { "nvim-mini/mini.icons" },
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    },
    opts = {
      options = {
        separator_style = "slope",
        show_close_icon = false,
        themable = true,
        -- stylua: ignore
        close_command = function(n) Snacks.bufdelete(n) end,
        -- stylua: ignore
        right_mouse_command = function(n) Snacks.bufdelete(n) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        offsets = {
          {
            filetype = "snacks_layout_box",
          },
          {
            filetype = "SymbolsSidebar",
          },
        },
        buffer_close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        indicator = {
          icon = "▎", -- this should be omitted if indicator style is not 'icon'
          style = "underline",
        },
        diagnostics_indicator = function(count, level, _diagnostics_dict, _context)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,
        get_element_icon = function(opts)
          return require("mini.icons").get("filetype", opts.filetype)
        end,
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    cond = not vim.g.vscode,
    init = function()
      vim.opt.laststatus = 3
      vim.opt.splitkeep = "screen"
    end,
    opts = {
      animate = {
        enabled = false,
      },
      options = {
        left = { size = 0.15 },
        bottom = { size = 0.2 },
        right = { size = 0.15 },
      },
      bottom = {
        { title = "Neotest Output", ft = "neotest-output-panel" },
        { ft = "trouble", title = "Diagnostics" },
        {
          title = "Snacks Terminal",
          ft = "snacks_terminal",
          filter = function(_buf, win)
            return vim.api.nvim_win_get_config(win).relative == ""
          end,
        },
      },
      left = {
        {
          title = "Snacks Explorer",
          ft = "snacks_layout_box",
          pinned = true,
          size = { height = 0.7 },
          open = function()
            Snacks.explorer()
          end,
          filter = function(_buf, win)
            return vim.api.nvim_win_get_config(win).relative == ""
          end,
        },
      },
      right = {
        { title = "Grug Far", ft = "grug-far", size = { height = 0.30 } },
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
  },
  { "adlrwbr/keep-split-ratio.nvim", cond = not vim.g.vscode, opts = {} },
  {
    "Bekaboo/dropbar.nvim",
    cond = not vim.g.vscode,
    event = "BufEnter",
    config = function()
      local dropbar_api = require("dropbar.api")
      vim.keymap.set("n", "<leader>cb", dropbar_api.pick, { desc = "Breadcrumb: Pick symbols" })
      vim.keymap.set("n", "<leader>c[", dropbar_api.goto_context_start, { desc = "Breadcrumb: Go to start" })
      vim.keymap.set("n", "<leader>c]", dropbar_api.select_next_context, { desc = "Breadcrumb: Select next" })
    end,
  },
}
