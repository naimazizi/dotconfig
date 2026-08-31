local function toggle_terminal()
  Snacks.terminal.toggle(nil, {})
end

return {
  {
    "folke/snacks.nvim",
    vscode = false,
    priority = 1000,
    lazy = false,
    keys = {
      {
        "<leader>bi",
        function()
          Snacks.bufdelete.invisible()
        end,
        desc = "Delete Invisible Buffers",
      },
      {
        "<leader>fz",
        function()
          Snacks.picker.zoxide()
        end,
        desc = "Zoxide",
      },
      {
        "<leader>fp",
        function()
          Snacks.picker.projects()
        end,
        desc = "Project",
      },
      {
        "<leader>si",
        function()
          Snacks.picker.icons()
        end,
        desc = "Icon picker",
      },
      {
        "<leader>su",
        function()
          Snacks.picker.undo()
        end,
        desc = "Undotree",
      },
      {
        "<leader>sr",
        function()
          Snacks.picker.resume()
        end,
        desc = "Resume",
      },
      {
        "<leader>sk",
        function()
          Snacks.picker.keymaps()
        end,
        desc = "Keymaps",
      },
      {
        "<leader>sm",
        function()
          Snacks.picker.marks()
        end,
        desc = "Marks",
      },
      {
        "<leader>sd",
        function()
          Snacks.picker.diagnostics_buffer()
        end,
        desc = "Diagnostics",
      },
      {
        "<leader>sD",
        function()
          Snacks.picker.diagnostics()
        end,
        desc = "Diagnostics Workspace",
      },
      {
        "<leader>sq",
        function()
          Snacks.picker.qflist()
        end,
        desc = "Quickfix",
      },
      {
        "<leader>sl",
        function()
          Snacks.picker.loclist()
        end,
        desc = "Loclist",
      },
      {
        "<leader>fh",
        function()
          Snacks.picker.help()
        end,
        desc = "Help",
      },
      {
        "<leader>s/",
        function()
          Snacks.picker.command_history()
        end,
        desc = "Command History",
      },
      {
        "<leader>gc",
        function()
          Snacks.picker.git_log_file()
        end,
        desc = "Buffer Commits",
      },
      {
        "<leader>gC",
        function()
          Snacks.picker.git_log()
        end,
        desc = "Commits",
      },
      {
        "<leader>bb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "List buffers",
      },
      {
        "<leader>uc",
        function()
          Snacks.picker.colorschemes()
        end,
        desc = "Colorschemes",
      },
      { "<C-/>", toggle_terminal, mode = { "n", "t" }, desc = "Toggle terminal" },
      { "<C-`>", toggle_terminal, mode = { "n", "t" }, desc = "Toggle terminal" },
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
          Snacks.picker.gh_pr()
        end,
        desc = "GitHub Pull Requests (all)",
      },
    },
    ---@type snacks.Config
    opts = {
      image = { enabled = true },

      input = { enabled = true },

      picker = {
        ui_select = true,
        layout = require("utils.pick").layout,
        sources = {
          lsp_definitions = { jump = { unique = true } },
          lsp_type_definitions = { jump = { unique = true } },
          lsp_implementations = { jump = { unique = true } },
        },
        matcher = {
          fuzzy = true, -- use fuzzy matching
          smartcase = true, -- use smartcase
          ignorecase = true, -- use ignorecase
          sort_empty = false, -- sort results when the search string is empty
          filename_bonus = true, -- give bonus for matching file names (last part of the path)
          file_pos = true, -- support patterns like `file:line:col` and `file:line`
          cwd_bonus = true, -- give bonus for matching files in the cwd
          frecency = true, -- frecency bonus
          history_bonus = true, -- give more weight to chronological order
        },
        formatters = {
          file = {
            filename_first = true, -- display filename before the file path
            ---@type "left"|"center"|"right"
            truncate = "center",
            min_width = 40, -- minimum length of the truncated path
          },
        },
        win = {
          input = {
            keys = {
              ["<a-o>"] = { "opencode_send", mode = { "n", "i" } },
            },
          },
        },
        actions = {
          opencode_send = function(picker)
            local items = vim.tbl_map(function(item)
              return item.file and require("opencode").format({ path = item.file, from = item.pos, to = item.end_pos })
                or item.text
            end, picker:selected({ fallback = true }))

            require("opencode").prompt(table.concat(items, ", ") .. " ")
          end,
        },
      },

      quickfile = { enabled = true },

      bigfile = { enabled = true },

      terminal = { enabled = true },

      gitbrowse = { enabled = true },

      gh = { enabled = true },

      lazygit = {
        enabled = true,
        config = {
          os = {
            -- override the `nvim-remote` preset's `e` (edit) command to open in the
            -- current window (--remote) instead of a new tab (--remote-tab).
            -- No "outside nvim" fallback needed: lazygit only ever runs inside
            -- our own Snacks terminal, so $NVIM is always set.
            edit = 'nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote {{filename}}',
            editAtLine = 'nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote {{filename}} && nvim --server "$NVIM" --remote-send ":{{line}}<CR>"',
          },
        },
      },

      scroll = { enabled = true },

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
              action = ":lua require('fff').find_files()",
            },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            {
              icon = " ",
              key = "g",
              desc = "Find Text",
              action = ":lua require('fff').live_grep()",
            },
            {
              icon = " ",
              key = "p",
              desc = "Find Folder (Project)",
              action = ":lua Snacks.dashboard.pick('zoxide')",
            },
            {
              icon = " ",
              key = "r",
              desc = "Recent Files",
              action = ":lua Snacks.dashboard.pick('history')",
            },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua require('fff').find_files_in_dir(vim.fn.stdpath('config'))",
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
  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    vscode = false,
    opts = {},
    keys = {
      {
        "<leader>st",
        function()
          Snacks.picker.todo_comments()
        end,
        desc = "Todo",
      },
      {
        "<leader>sT",
        function()
          Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME", "NOTE", "HACK" } })
        end,
        desc = "Todo/Fix/Fixme/Note/Hack",
      },
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next todo comment",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Next todo comment",
      },
    },
  },
}
