return {
  { "adlrwbr/keep-split-ratio.nvim", vscode = false, opts = {} },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    vscode = false,
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
    vscode = false,
    config = function()
      require("lensline").setup({
        profiles = {
          {
            name = "minimal",
            style = {
              placement = "inline",
              prefix = "",
            },
            providers = { -- Array format: order determines display sequence
              {
                name = "usages",
                enabled = true,
                include = { "refs", "defs", "impls" },
                breakdown = true,
                show_zero = true,
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
                name = "function_length",
                enabled = true,
                event = { "BufWritePost", "TextChanged" },
                handler = function(bufnr, func_info, provider_config, callback)
                  local utils = require("lensline.utils")
                  local function_lines = utils.get_function_lines(bufnr, func_info)
                  local func_line_count = math.max(0, #function_lines - 1) -- Subtract 1 for signature
                  local total_lines = vim.api.nvim_buf_line_count(bufnr)

                  -- Show line count for all functions
                  callback({
                    line = func_info.line,
                    text = string.format("(%d/%d lines)", func_line_count, total_lines),
                  })
                end,
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
    vscode = false,
    event = "BufRead",
    config = function()
      require("numb").setup()
    end,
  },
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    vscode = false,
    init = function()
      vim.opt.laststatus = 3
      vim.opt.splitkeep = "screen"
    end,
    keys = {
      -- {
      --   "<leader>uE",
      --   function()
      --     require("edgy").toggle()
      --   end,
      --   desc = "Edgy Toggle",
      -- },
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
    config = function()
      opts = {
        animate = {
          enabled = false,
        },
        options = {
          left = { size = 0.15 },
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
            title = "Snacks Terminal",
            ft = "snacks_terminal",
            filter = function(_buf, win)
              return vim.api.nvim_win_get_config(win).relative == ""
            end,
          },
        },
        left = {
          {
            title = "Explorer",
            ft = "snacks_layout_box",
            open = function()
              require("snacks").explorer()
            end,
            pinned = true,
            filter = function(_buf, win)
              return vim.api.nvim_win_get_config(win).relative == ""
            end,
          },
          {
            title = "Outline",
            ft = "SymbolsSidebar",
            pinned = true,
            open = "SymbolsToggle",
          },
        },
        right = {
          { title = "Grug Far", ft = "grug-far", size = { height = 0.30 } },
          { title = "AI", ft = "codecompanion", pinned = true, open = "CodeCompanionChat", size = { height = 0.30 } },
          {
            title = "Overseer",
            ft = "OverseerList",
            open = function()
              require("overseer").open()
            end,
            size = { height = 0.4 },
          },
          { title = "Neotest Summary", ft = "neotest-summary" },
          { title = "REPL", ft = "iron" },
        },
      }
      require("edgy").setup(opts)

      -- trouble
      for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
        opts[pos] = opts[pos] or {}
        table.insert(opts[pos], {
          ft = "trouble",
          filter = function(_buf, win)
            return vim.w[win].trouble
              and vim.w[win].trouble.position == pos
              and vim.w[win].trouble.type == "split"
              and vim.w[win].trouble.relative == "editor"
              and not vim.w[win].trouble_preview
          end,
        })
      end

      -- snacks terminal
      for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
        opts[pos] = opts[pos] or {}
        table.insert(opts[pos], {
          ft = "snacks_terminal",
          size = { height = 0.4 },
          title = "%{b:snacks_terminal.id}: %{b:term_title}",
          filter = function(_buf, win)
            return vim.w[win].snacks_win
              and vim.w[win].snacks_win.position == pos
              and vim.w[win].snacks_win.relative == "editor"
              and not vim.w[win].trouble_preview
          end,
        })
      end
      return opts
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    vscode = false,
    optional = true,
    event = "VeryLazy",
    dependencies = {
      {
        "letieu/harpoon-lualine",
        event = "VeryLazy",
        cond = not vim.g.vscode,
      },
      { "franco-ruggeri/codecompanion-lualine.nvim" },
    },
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, { require("recorder").displaySlots })
      table.insert(opts.sections.lualine_x, { "harpoon2" })
      table.insert(opts.sections.lualine_x, { "overseer" })
      table.insert(opts.sections.lualine_x, { "venv-selector" })
      table.insert(opts.sections.lualine_x, {
        function()
          return "  " .. require("dap").status()
        end,
        cond = function()
          return package.loaded["dap"] and require("dap").status() ~= ""
        end,
        color = function()
          return { fg = Snacks.util.color("Debug") }
        end,
      })
      table.insert(opts.sections.lualine_x, 2, {
        "codecompanion",
        icon = " cc",
        spinner_symbols = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
        done_symbol = "✓",
      })
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
    "Fildo7525/pretty_hover",
    vscode = false,
    event = "LspAttach",
    opts = {},
    config = function(opts)
      require("pretty_hover").setup(opts)
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "K", false }

      vim.keymap.set("n", "K", function()
        require("pretty_hover").hover()
      end, { desc = "Hover (Pretty)" })
    end,
  },
  {
    "oskarrrrrrr/symbols.nvim",
    vscode = false,
    cmd = "SymbolsToggle",
    keys = { { "<leader>cs", "<cmd>SymbolsToggle<cr>", desc = "Toggle Outline" } },
    config = function()
      local r = require("symbols.recipes")
      require("symbols").setup(r.DefaultFilters, r.AsciiSymbols, {
        sidebar = {
          show_inline_details = true,
          auto_peek = false,
          preview = {
            show_always = false,
          },
        },
      })
    end,
  },
  {
    "A7Lavinraj/fyler.nvim",
    cmd = "Fyler",
    vscode = false,
    keys = {
      {
        "<leader>fE",
        "<cmd>Fyler<cr>",
        desc = "Explorer Fyler (cwd)",
      },
      {
        "<leader>E",
        "<cmd>Fyler<cr>",
        desc = "Explorer Fyler (cwd)",
      },
    },
    opts = {
      win = {
        border = "double",
        kind = "float",
      },
    },
  },
  {
    "folke/trouble.nvim",
    optional = true,
    keys = {
      { "<leader>cs", false },
    },
  },
  {
    "folke/snacks.nvim",
    keys = { {
      "<leader>fE",
      false,
    }, { "<leader>E", "<leader>fE", false } },
    opts = {
      indent = {
        indent = {
          priority = 1,
          enabled = true, -- enable indent guides
          char = "│",
          only_scope = false, -- only show indent guides of the scope
          only_current = false, -- only show indent guides in the current window
          hl = "SnacksIndent",
        },
        animate = {
          style = "out",
          easing = "linear",
          duration = {
            step = 20, -- ms per step
            total = 500, -- maximum duration
          },
        },
        scope = {
          enabled = true, -- enable highlighting the current scope
          priority = 200,
          char = "│",
          underline = false, -- underline the start of the scope
          only_current = true, -- only show scope in the current window
          hl = "SnacksIndentScope", ---@type string|string[] hl group for scopes
        },
        chunk = {
          -- when enabled, scopes will be rendered as chunks, except for the
          -- top-level scope which will be rendered as a scope.
          enabled = true,
          -- only show chunk scopes in the current window
          only_current = true,
          priority = 200,
          hl = "SnacksIndentChunk", ---@type string|string[] hl group for chunk scopes
          char = {
            corner_top = "╭",
            corner_bottom = "╰",
            horizontal = "─",
            vertical = "│",
            arrow = ">",
          },
        },
      },
      scope = {},
    },
  },
  {
    "akinsho/bufferline.nvim",
    optional = true,
    opts = function()
      local Offset = require("bufferline.offset")
      if not Offset.edgy then
        local get = Offset.get
        Offset.get = function()
          if package.loaded.edgy then
            local old_offset = get()
            local layout = require("edgy.config").layout
            local ret = { left = "", left_size = 0, right = "", right_size = 0 }
            for _, pos in ipairs({ "left", "right" }) do
              local sb = layout[pos]
              ---@diagnostic disable-next-line: param-type-not-match
              local title = " Sidebar" .. string.rep(" ", sb.bounds.width - 8)
              if sb and #sb.wins > 0 then
                ret[pos] = old_offset[pos .. "_size"] > 0 and old_offset[pos]
                  or pos == "left" and ("%#Bold#" .. title .. "%*" .. "%#BufferLineOffsetSeparator#│%*")
                  or pos == "right" and ("%#BufferLineOffsetSeparator#│%*" .. "%#Bold#" .. title .. "%*")
                ret[pos .. "_size"] = old_offset[pos .. "_size"] > 0 and old_offset[pos .. "_size"] or sb.bounds.width
              end
            end
            ret.total_size = ret.left_size + ret.right_size
            ---@diagnostic disable-next-line: unnecessary-if
            if ret.total_size > 0 then
              return ret
            end
          end
          return get()
        end
        Offset.edgy = true
      end
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    vscode = false,
    event = "BufRead",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text_pos = "right_align",
        delay = 500,
      },
    },
  },
}
