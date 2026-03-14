local fzf_bin = (vim.fn.executable("sk") == 1) and "sk" or nil
local algo = (vim.fn.executable("sk") == 1) and "arinae" or "frizbee"

local function fzf_lua_picker(fn, opts)
  return function(...)
    local ok, fzf = pcall(require, "fzf-lua")
    if not ok then
      vim.notify("fzf-lua not available")
      return
    end
    if type(fzf[fn]) ~= "function" then
      vim.notify("fzf-lua picker not available")
      return
    end
    local merged_opts = vim.tbl_extend("force", opts or {}, select(1, ...) or {})
    return fzf[fn](merged_opts)
  end
end

return {
  {
    "ibhagwan/fzf-lua",
    vscode = false,
    event = "VeryLazy",
    keys = {
      { "<leader>ff", fzf_lua_picker("files", {}), desc = "Find files" },
      { "<leader>fF", fzf_lua_picker("files", { cwd = vim.fn.expand("%:p:h") }), desc = "Find files (cwd)" },
      { "<leader>fg", fzf_lua_picker("live_grep", {}), desc = "Grep" },
      { "<leader>sR", fzf_lua_picker("resume", {}), desc = "Resume" },
      { "<leader>sk", fzf_lua_picker("keymaps", {}), desc = "Keymaps" },
      { "<leader>sm", fzf_lua_picker("marks", {}), desc = "Marks" },
      {
        "<leader>st",
        fzf_lua_picker("grep", { search = "TODO|HACK|PERF|NOTE|FIXME", no_esc = true }),
        desc = "TODO",
      },
      { "<leader>sd", fzf_lua_picker("diagnostics_document", {}), desc = "Diagnostics" },
      { "<leader>sD", fzf_lua_picker("diagnostics_workspace", {}), desc = "Diagnostics Workspace" },
      { "<leader>xx", fzf_lua_picker("diagnostics_workspace", {}), desc = "Diagnostics Workspace" },
      { "<leader>sq", fzf_lua_picker("quickfix", {}), desc = "Quickfix" },
      { "<leader>fr", fzf_lua_picker("oldfiles", {}), desc = "Recent" },
      { "<leader>fh", fzf_lua_picker("help_tags", {}), desc = "Help" },
      { "<leader>fz", fzf_lua_picker("zoxide", {}), desc = "Zoxide" },
      { "<leader>s/", fzf_lua_picker("command_history", {}), desc = "Command History" },
      { "<leader>gc", fzf_lua_picker("git_bcommits", {}), desc = "Buffer Commits" },
      { "<leader>gC", fzf_lua_picker("git_commits", {}), desc = "Commits" },
      { "<leader>gd", fzf_lua_picker("git_diff", {}), desc = "Diff" },
      { "<leader>gS", fzf_lua_picker("git_status", {}), desc = "Status" },
      { "<leader>bb", fzf_lua_picker("buffers", {}), desc = "List buffers" },
    },
    config = function()
      local fzf = require("fzf-lua")
      local config = fzf.config
      local actions = fzf.actions

      if not config or not config.defaults or not config.defaults.keymap then
        return
      end

      -- Quickfix
      config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
      config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
      config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
      config.defaults.keymap.fzf["ctrl-x"] = "jump"
      config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
      config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"
      config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
      config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"

      fzf.setup({
        { "telescope" },
        fzf_bin = fzf_bin,
        fzf_colors = true,
        fzf_opts = {
          ["--no-scrollbar"] = true,
          ["--algo"] = algo,
        },

        files = {
          cwd_prompt = false,
          formatter = "path.filename_first",
          actions = actions and {
            ["alt-i"] = { actions.toggle_ignore },
            ["alt-h"] = { actions.toggle_hidden },
          } or nil,
        },

        grep = {
          actions = actions and {
            ["alt-i"] = { actions.toggle_ignore },
            ["alt-h"] = { actions.toggle_hidden },
          } or nil,
          multiline = 2,
        },
        lsp = {
          symbols = {
            symbol_style = 2,
          },
        },
      })
      fzf.register_ui_select()
    end,
  },
  {
    "dmtrKovalenko/fff.nvim",
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    opts = {
      debug = {
        enabled = false,
      },
      git = {
        status_text_color = true,
      },
    },
    lazy = false,
    keys = {
      {
        "<leader><leader>",
        function()
          require("fff").find_files()
        end,
        desc = "FFFind files",
      },
      {
        "<leader>/",
        function()
          require("fff").live_grep({
            grep = {
              modes = { "plain", "fuzzy", "regex" },
            },
          })
        end,
        desc = "Live fffuzy grep",
      },
      {
        "<leader>sw",
        function()
          require("fff").live_grep({ query = vim.fn.expand("<cword>") })
        end,
        desc = "Search current word",
      },
    },
  },
  {
    "folke/snacks.nvim",
    vscode = false,
    priority = 1000,
    lazy = false,
    keys = {
      { "<leader>n", ":lua Snacks.notifier.show_history()<CR>", desc = "Notifications" },
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete Buffer",
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

      notifier = { enabled = true, top_down = false },

      styles = {
        notification = {
          wo = { wrap = true }, -- Wrap notifications
        },
      },

      scroll = { enabled = true },

      indent = {
        indent = {
          priority = 1,
          enabled = true, -- enable indent guides
          char = "╎",
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
              action = ":lua FzfLua.files()",
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
      -- Make Snacks the default notification system
      vim.notify = require("snacks.notifier").notify

      ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
      local progress = vim.defaulttable()
      vim.api.nvim_create_autocmd("LspProgress", {
        ---@param ev vim.api.keyset.create_autocmd.callback_args
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
          if not client or type(value) ~= "table" then
            return
          end
          local p = progress[client.id]

          for i = 1, #p + 1 do
            if i == #p + 1 or (p[i] and p[i].token == ev.data.params.token) then
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
          vim.notify(table.concat(msg, "\n"), vim.log.levels.INFO, {
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
  },
}
