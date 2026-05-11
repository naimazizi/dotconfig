local layout = require("utils.pick").layout

return {
  {
    "folke/snacks.nvim",
    vscode = false,
    priority = 1000,
    lazy = false,
    keys = {
      {
        "<leader><leader>",
        function()
          Snacks.picker.smart({ layout = layout })
        end,
        desc = "Find files",
      },
      {
        "<leader>/",
        function()
          Snacks.picker.grep({
            layout = layout,
          })
        end,
        desc = "Live Grep",
      },
      {
        "<leader>sw",
        function()
          Snacks.picker.grep_word({ layout = layout })
        end,
        desc = "Search current word",
        mode = { "n", "x" },
      },
      {
        "<leader>ff",
        function()
          Snacks.picker.files({ layout = layout })
        end,
        desc = "Find files",
      },
      {
        "<leader>fF",
        function()
          Snacks.picker.files({ cwd = vim.fn.expand("%:p:h"), layout = layout })
        end,
        desc = "Find files (cwd)",
      },
      {
        "<leader>fg",
        function()
          Snacks.picker.grep({ layout = layout })
        end,
        desc = "Live Grep",
      },
      {
        "<leader>sR",
        function()
          Snacks.picker.resume()
        end,
        desc = "Resume",
      },
      {
        "<leader>sk",
        function()
          Snacks.picker.keymaps({ layout = layout })
        end,
        desc = "Keymaps",
      },
      {
        "<leader>sm",
        function()
          Snacks.picker.marks({ layout = layout })
        end,
        desc = "Marks",
      },
      {
        "<leader>sd",
        function()
          Snacks.picker.diagnostics_buffer({ layout = layout })
        end,
        desc = "Diagnostics",
      },
      {
        "<leader>sD",
        function()
          Snacks.picker.diagnostics({ layout = layout })
        end,
        desc = "Diagnostics Workspace",
      },
      {
        "<leader>sq",
        function()
          Snacks.picker.qflist({ layout = layout })
        end,
        desc = "Quickfix",
      },
      {
        "<leader>sl",
        function()
          Snacks.picker.loclist({ layout = layout })
        end,
        desc = "Loclist",
      },
      {
        "<leader>fr",
        function()
          Snacks.picker.recent({ layout = layout })
        end,
        desc = "Recent",
      },
      {
        "<leader>fz",
        function()
          Snacks.picker.zoxide({ layout = layout })
        end,
        desc = "Zoxide",
      },
      {
        "<leader>fp",
        function()
          Snacks.picker.projects({ layout = layout })
        end,
        desc = "Project",
      },
      {
        "<leader>fh",
        function()
          Snacks.picker.help({ layout = layout })
        end,
        desc = "Help",
      },
      {
        "<leader>s/",
        function()
          Snacks.picker.command_history({ layout = layout })
        end,
        desc = "Command History",
      },
      {
        "<leader>gc",
        function()
          Snacks.picker.git_log_file({ layout = layout })
        end,
        desc = "Buffer Commits",
      },
      {
        "<leader>gC",
        function()
          Snacks.picker.git_log({ layout = layout })
        end,
        desc = "Commits",
      },
      {
        "<leader>bb",
        function()
          Snacks.picker.buffers({ layout = layout })
        end,
        desc = "List buffers",
      },
      {
        "<leader>si",
        function()
          Snacks.picker.icons({ layout = layout })
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
      {
        "<leader>su",
        function()
          Snacks.picker.undo({ layout = layout })
        end,
        desc = "Undotree",
      },
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
          Snacks.picker.gh_issue({ layout = layout })
        end,
        desc = "GitHub Issues (open)",
      },
      {
        "<leader>gI",
        function()
          Snacks.picker.gh_issue({ state = "all", layout = layout })
        end,
        desc = "GitHub Issues (all)",
      },
      {
        "<leader>gp",
        function()
          Snacks.picker.gh_pr({ layout = layout })
        end,
        desc = "GitHub Pull Requests (open)",
      },
      {
        "<leader>gP",
        function()
          Snacks.picker.gh_pr({ state = "all", layout = layout })
        end,
        desc = "GitHub Pull Requests (all)",
      },
      {
        "<leader>uc",
        function()
          Snacks.picker.colorschemes({ state = "all", layout = layout })
        end,
        desc = "Colorschemes",
      },
      {
        "<leader>n",
        function()
          Snacks.picker.notifications({ state = "all", layout = layout })
        end,
        desc = "Notifications",
      },
    },
    ---@type snacks.Config
    opts = {
      image = { enabled = true },

      input = { enabled = true },

      picker = {
        ui_select = true,
        sources = {
          lsp_definitions = { jump = { unique = true } },
          lsp_type_definitions = { jump = { unique = true } },
          lsp_implementations = { jump = { unique = true } },
        },
        matcher = {
          fuzzy = true, -- use fuzzy matching
          smartcase = true, -- use smartcase
          ignorecase = true, -- use ignorecase
          sort_empty = true, -- sort results when the search string is empty
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
      },

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

      notifier = {
        enabled = true,
        style = "fancy",
        top_down = false,
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
              action = ":lua Snacks.picker.files()",
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

      local pick_utils = require("utils.pick")
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          pick_utils.lsp_keymaps(args.buf)
        end,
      })

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

          ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
          local progress = vim.defaulttable()
          vim.api.nvim_create_autocmd("LspProgress", {
            ---@diagnostic disable-next-line: assign-type-mismatch
            ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
            callback = function(ev)
              local client = vim.lsp.get_client_by_id(ev.data.client_id)
              local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
              if not client or type(value) ~= "table" then
                return
              end
              local p = progress[client.id]

              for i = 1, #p + 1 do
                ---@diagnostic disable-next-line: need-check-nil
                if i == #p + 1 or p[i].token == ev.data.params.token then
                  p[i] = {
                    token = ev.data.params.token,
                    msg = ("[%3d%%] %s%s"):format(
                      value.kind == "end" and 100 or value.percentage or 100,
                      value.title or "",
                      value.message and (" **%s**"):format(value.message) or ""
                    ),
                    done = value.kind == "end",
                  }
                  break
                end
              end

              local msg = {} ---@type string[]
              progress[client.id] = vim.tbl_filter(function(v)
                return table.insert(msg, v.msg) or not v.done
              end, p)

              local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
              ---@diagnostic disable-next-line: param-type-mismatch
              vim.notify(table.concat(msg, "\n"), "info", {
                id = "lsp_progress",
                title = client.name,
                opts = function(notif)
                  notif.icon = #progress[client.id] == 0 and " "
                    or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
                end,
              })
            end,
          })
        end,
      })
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
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
