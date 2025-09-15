local function augroup(name)
  return vim.api.nvim_create_augroup("custom_augroup_" .. name, { clear = true })
end

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "checkhealth",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

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
  {
    "Fildo7525/pretty_hover",
    cond = not vim.g.vscode,
    event = "LspAttach",
    opts = {},
    config = function(opts)
      require("pretty_hover").setup(opts)

      vim.keymap.set("n", "K", function()
        require("pretty_hover").hover()
      end, { desc = "Hover (LSP)" })
    end,
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    cond = not vim.g.vscode,
    config = function()
      require("tiny-inline-diagnostic").setup({
        preset = "modern",
        transparent_bg = false,
        transparent_cursorline = true,
        options = {
          show_source = {
            enabled = false,
            if_many = true,
          },
          set_arrow_to_diag_color = true,
          throttle = 20,
          softwrap = 30,
          multilines = {
            enabled = true,
            trim_whitespaces = true,
            tabstop = 4,
          },
          -- Display all diagnostic messages on the cursor line, not just those under cursor
          show_all_diags_on_cursorline = false,
          -- Enable diagnostics in Insert mode
          -- If enabled, consider setting throttle to 0 to avoid visual artifacts
          enable_on_insert = false,
          -- Enable diagnostics in Select mode (e.g., when auto-completing with Blink)
          enable_on_select = false,
          -- Configuration for breaking long messages into separate lines
          break_line = {
            enabled = true,
            after = 30,
          },
          format = nil,
          virt_texts = {
            priority = 2048,
          },
        },
        -- List of filetypes to disable the plugin for
        disabled_ft = {},
      })
      vim.diagnostic.config({ virtual_text = false }) -- Disable default virtual text
    end,
  },
  {
    "oribarilan/lensline.nvim",
    event = "LspAttach",
    cond = not vim.g.vscode,
    config = function()
      require("lensline").setup({
        profiles = {
          {
            name = "default",
            providers = { -- Array format: order determines display sequence
              {
                name = "references",
                enabled = true, -- enable references provider
                quiet_lsp = true, -- suppress noisy LSP log messages (e.g., Pyright reference spam)
              },
              {
                name = "last_author",
                enabled = true, -- enabled by default with caching optimization
                cache_max_files = 50, -- maximum number of files to cache blame data for (default: 50)
              },
              -- built-in providers that are disabled by default:
              {
                name = "diagnostics",
                enabled = true, -- disabled by default - enable explicitly to use
                min_level = "WARN", -- only show WARN and ERROR by default (HINT, INFO, WARN, ERROR)
              },
              {
                name = "complexity",
                enabled = false, -- disabled by default - enable explicitly to use
                min_level = "L", -- only show L (Large) and XL (Extra Large) complexity by default
              },
            },
          },
        },

        style = {
          separator = " • ", -- separator between all lens attributes
          highlight = "Comment", -- highlight group for lens text
          prefix = "┃ ", -- prefix before lens content
          use_nerdfont = true, -- enable nerd font icons in built-in providers
        },
        limits = {
          exclude = {
            -- see config.lua for extensive list of default patterns
          },
          exclude_gitignored = true, -- respect .gitignore by not processing ignored files
          max_lines = 1000, -- process only first N lines of large files
          max_lenses = 70, -- skip rendering if too many lenses generated
        },
        debounce_ms = 500, -- unified debounce delay for all providers
        debug_mode = false, -- enable debug output for development, see CONTRIBUTE.md
      })
    end,
  },
  {
    "nacro90/numb.nvim",
    cond = not vim.g.vscode,
    event = "BufRead",
    config = function()
      require("numb").setup()
    end,
  },
  {
    "chentoast/marks.nvim",
    event = "BufRead",
    cond = not vim.g.vscode,
    opts = {},
  },
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
    },
    event = "LspAttach",
    cond = not vim.g.vscode,
    opts = {
      backend = "vim",
      picker = "snacks",
      signs = {
        quickfix = { "", { link = "DiagnosticWarning" } },
        others = { "", { link = "DiagnosticWarning" } },
        refactor = { "", { link = "DiagnosticInfo" } },
        ["refactor.move"] = { "󰪹", { link = "DiagnosticInfo" } },
        ["refactor.extract"] = { "", { link = "DiagnosticError" } },
        ["source.organizeImports"] = { "", { link = "DiagnosticWarning" } },
        ["source.fixAll"] = { "󰃢", { link = "DiagnosticError" } },
        ["source"] = { "", { link = "DiagnosticError" } },
        ["rename"] = { "󰑕", { link = "DiagnosticWarning" } },
        ["codeAction"] = { "", { link = "DiagnosticWarning" } },
      },
    },
    config = function(_, opts)
      require("tiny-code-action").setup(opts)

      vim.keymap.set({ "n", "x" }, "<leader>ca", function()
        require("tiny-code-action").code_action()
      end, { desc = "Code Action", noremap = true, silent = true })
    end,
  },
}
