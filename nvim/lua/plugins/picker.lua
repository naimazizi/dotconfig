local function theme(opts)
  return require("telescope.themes").get_ivy(opts)
end

return {
  {
    "nvim-telescope/telescope.nvim",
    vscode = false,
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-frecency.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "nvim-telescope/telescope-dap.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "jvgrootveld/telescope-zoxide",
      "natecraddock/telescope-zf-native.nvim",
    },
    keys = {
      {
        "<leader><leader>",
        function()
          require("telescope").extensions.frecency.frecency(theme({
            workspace = "CWD",
          }))
        end,
        desc = "Find files",
      },
      {
        "<leader>/",
        function()
          require("telescope").extensions.live_grep_args.live_grep_args(theme())
        end,
        desc = "Live Grep",
      },
      {
        "<leader>sw",
        function()
          require("telescope.builtin").grep_string(theme())
        end,
        desc = "Search current word",
      },
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files(theme())
        end,
        desc = "Find files",
      },
      {
        "<leader>fF",
        function()
          require("telescope.builtin").find_files(theme({ cwd = vim.fn.expand("%:p:h") }))
        end,
        desc = "Find files (cwd)",
      },
      {
        "<leader>fg",
        function()
          require("telescope").extensions.live_grep_args.live_grep_args(theme())
        end,
        desc = "Live Grep",
      },
      {
        "<leader>sR",
        function()
          require("telescope.builtin").resume(theme())
        end,
        desc = "Resume",
      },
      {
        "<leader>sk",
        function()
          require("telescope.builtin").keymaps(theme())
        end,
        desc = "Keymaps",
      },
      {
        "<leader>sm",
        function()
          require("telescope.builtin").marks(theme())
        end,
        desc = "Marks",
      },
      {
        "<leader>st",
        function()
          require("telescope.builtin").grep_string(theme({ search = "TODO|HACK|PERF|NOTE|FIXME" }))
        end,
        desc = "TODO",
      },
      {
        "<leader>sd",
        function()
          require("telescope.builtin").diagnostics(theme({ bufnr = 0 }))
        end,
        desc = "Diagnostics",
      },
      {
        "<leader>sD",
        function()
          require("telescope.builtin").diagnostics(theme())
        end,
        desc = "Diagnostics Workspace",
      },
      {
        "<leader>sq",
        function()
          require("telescope.builtin").quickfix(theme())
        end,
        desc = "Quickfix",
      },
      {
        "<leader>fr",
        function()
          require("telescope").extensions.frecency.frecency(theme())
        end,
        desc = "Recent",
      },
      {
        "<leader>fh",
        function()
          require("telescope.builtin").help_tags(theme())
        end,
        desc = "Help",
      },
      {
        "<leader>fz",
        function()
          require("telescope").extensions.zoxide.list(theme())
        end,
        desc = "Zoxide",
      },
      {
        "<leader>s/",
        function()
          require("telescope.builtin").command_history(theme())
        end,
        desc = "Command History",
      },
      {
        "<leader>gc",
        function()
          require("telescope.builtin").git_bcommits(theme())
        end,
        desc = "Buffer Commits",
      },
      {
        "<leader>gC",
        function()
          require("telescope.builtin").git_commits(theme())
        end,
        desc = "Commits",
      },
      {
        "<leader>gd",
        function()
          require("telescope.builtin").git_diff(theme())
        end,
        desc = "Diff",
      },
      {
        "<leader>gS",
        function()
          require("telescope.builtin").git_status(theme())
        end,
        desc = "Status",
      },
      {
        "<leader>bb",
        function()
          require("telescope.builtin").buffers(theme())
        end,
        desc = "List buffers",
      },
      {
        "<leader>dd",
        function()
          require("telescope").extensions.dap.commands(theme())
        end,
        desc = "DAP commands",
      },
      {
        "<leader>dV",
        function()
          require("telescope").extensions.dap.variables(theme())
        end,
        desc = "DAP variables",
      },
      {
        "<leader>dv",
        function()
          require("telescope").extensions.dap.list_breakpoints(theme())
        end,
        desc = "DAP breakpoint",
      },
      {
        "<leader>df",
        function()
          require("telescope").extensions.dap.configurations(theme())
        end,
        desc = "Configuration",
      },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local lga_actions = require("telescope-live-grep-args.actions")

      telescope.setup({
        defaults = {
          path_display = { "smart" },
          sorting_strategy = "ascending",
          preview = {
            check_mime_type = false,
            timeout = 500,
            filesize_limit = 0.3, -- MB
          },
          mappings = {
            i = {
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-b>"] = actions.preview_scrolling_up,
              ["<C-k>"] = lga_actions.quote_prompt(),
              ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              ["<C-space>"] = lga_actions.to_fuzzy_refine,
            },
            n = {
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-b>"] = actions.preview_scrolling_up,
              ["q"] = actions.close,
            },
          },
        },
        pickers = {
          find_files = {
            find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
            hidden = false,
          },
          live_grep = {
            additional_args = function()
              return { "--hidden", "--glob", "!.git" }
            end,
          },
          oldfiles = {
            sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
          },
          diagnostics = {
            severity_bound = vim.diagnostic.severity.HINT,
          },
          buffers = {
            sort_mru = true,
            ignore_current_buffer = false,
          },
          git_commits = {
            layout_strategy = "vertical",
          },
          git_bcommits = {
            layout_strategy = "vertical",
          },
        },
        extensions = {
          ["zf-native"] = {
            -- options for sorting file-like items
            file = {
              -- override default telescope file sorter
              enable = true,

              -- highlight matching text in results
              highlight_results = true,

              -- enable zf filename match priority
              match_filename = true,

              -- optional function to define a sort order when the query is empty
              initial_sort = nil,

              -- set to false to enable case sensitive matching
              smart_case = true,
            },

            -- options for sorting all other items
            generic = {
              -- override default telescope generic item sorter
              enable = true,

              -- highlight matching text in results
              highlight_results = true,

              -- disable zf filename match priority
              match_filename = false,

              -- optional function to define a sort order when the query is empty
              initial_sort = nil,

              -- set to false to enable case sensitive matching
              smart_case = true,
            },
          },
          frecency = {
            path_display = { "smart" },
            workspace_scan_cmd = nil,
            show_scores = false,
            show_unindexed = true,
            ignore_patterns = { "*.git/*", "*/tmp/*" },
            workspaces = {},
          },
          file_browser = {
            grouped = true,
            depth = true,
          },
          live_grep_args = {
            auto_quoting = true,
            default_text = "",
          },
          ["ui-select"] = {
            theme(),
          },
        },
      })

      -- Load extensions
      telescope.load_extension("zf-native")
      telescope.load_extension("frecency")
      telescope.load_extension("file_browser")
      telescope.load_extension("live_grep_args")
      telescope.load_extension("zoxide")
      telescope.load_extension("dap")
      telescope.load_extension("ui-select")
    end,
  },
  {
    "folke/snacks.nvim",
    vscode = false,
    priority = 1000,
    lazy = false,
    keys = {
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete Buffer",
      },
      {
        "<leader>ba",
        function()
          Snacks.bufdelete.all()
        end,
        desc = "Delete All Buffers",
      },
      {
        "<leader>bo",
        function()
          Snacks.bufdelete.other()
        end,
        desc = "Delete All Other Buffers",
      },
      {
        "<leader>b[",
        function()
          Snacks.bufdelete.left()
        end,
        desc = "Delete Buffer to the Left",
      },
      {
        "<leader>b]",
        function()
          Snacks.bufdelete.right()
        end,
        desc = "Delete Buffer to the Right",
      },
      {
        "<leader>si",
        function()
          Snacks.picker.icons()
        end,
        desc = "Icon picker",
      },
      {
        "<leader>e",
        function()
          Snacks.explorer()
        end,
        desc = "File Explorer",
      },
    },
    ---@type snacks.Config
    opts = {
      image = { enabled = true },

      input = { enabled = true },

      quickfile = { enabled = true },

      bigfile = { enabled = true },

      terminal = { enabled = true },

      gitbrowse = { enabled = true },

      gh = { enabled = true },

      lazygit = { enabled = true },

      scroll = { enabled = true },

      explorer = {
        replace_netrw = true,
        trash = true,
      },

      indent = {
        indent = {
          priority = 1,
          enabled = true,
          char = "╎",
          only_scope = false,
          only_current = false,
          hl = "SnacksIndent",
        },
        animate = {
          style = "out",
          easing = "linear",
          duration = {
            step = 20,
            total = 500,
          },
        },
        scope = {
          enabled = true,
          priority = 200,
          char = "│",
          underline = false,
          only_current = true,
          hl = "SnacksIndentScope",
        },
        chunk = {
          enabled = true,
          only_current = true,
          priority = 200,
          hl = "SnacksIndentChunk",
          char = {
            corner_top = "╭",
            corner_bottom = "╰",
            horizontal = "─",
            vertical = "│",
            arrow = ">",
          },
        },
      },

      toggle = { enabled = true },

      dashboard = {
        preset = {
          header = [[
  ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆
  ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦
        ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄
          ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄
        ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀
  ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄
⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄
⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄
⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄
    ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆
      ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃

    ]],

          ---@type snacks.dashboard.Item[]
          keys = {
            {
              icon = " ",
              key = "f",
              desc = "Find File",
              action = ":Telescope frecency workspace=CWD",
            },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            {
              icon = " ",
              key = "p",
              desc = "Find Folder (Project)",
              action = ":lua Snacks.dashboard.pick('zoxide')",
            },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('history')" },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          { section = "startup" },
        },
      },
    },
    config = function(_, opts)
      require("snacks").setup(opts)

      vim.api.nvim_create_autocmd("User", {
        desc = "Snacks toggle keymap",
        pattern = "VeryLazy",
        callback = function()
          Snacks.toggle
            .new({
              id = "format_on_save",
              name = "Format on Save (global)",
              get = function()
                return not vim.g.disable_autoformat
              end,
              set = function(state)
                vim.g.disable_autoformat = not state
              end,
            })
            :map("<leader>uf")

          Snacks.toggle
            .new({
              id = "format_on_save_buffer",
              name = "Format on Save (buffer)",
              get = function()
                return not vim.b.disable_autoformat
              end,
              set = function(state)
                vim.b.disable_autoformat = not state
              end,
            })
            :map("<leader>uF")

          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")

          Snacks.toggle.inlay_hints():map("<leader>uh")

          Snacks.toggle.diagnostics():map("<leader>ud")
        end,
      })
    end,
  },
}
