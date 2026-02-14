local fzf_bin = (vim.fn.executable("sk") == 1) and "sk" or nil

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
    dependencies = {
      "folke/snacks.nvim",
    },
    keys = {
      { "<leader>ff", fzf_lua_picker("files", {}), desc = "Find files" },
      { "<leader>fF", fzf_lua_picker("files", { cwd = vim.fn.expand("%:p:h") }), desc = "Find files (cwd)" },
      { "<leader>fg", fzf_lua_picker("live_grep", {}), desc = "Grep" },
      { "<leader>/", fzf_lua_picker("live_grep", { cwd = vim.fn.getcwd() }), desc = "Grep (cwd)" },
      { "<leader>sw", fzf_lua_picker("grep_cword", {}), desc = "Search word under cursor" },
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
      { "<leader>fr", fzf_lua_picker("oldfiles", {}), desc = "Recent" },
      { "<leader>fh", fzf_lua_picker("help_tags", {}), desc = "Help" },
      { "<leader>fz", fzf_lua_picker("zoxide", {}), desc = "Zoxide" },
      { "<leader>s/", fzf_lua_picker("command_history", {}), desc = "Command History" },
      { "<leader>gc", fzf_lua_picker("git_bcommits", {}), desc = "Buffer Commits" },
      { "<leader>gC", fzf_lua_picker("git_commits", {}), desc = "Commits" },
      { "<leader>gd", fzf_lua_picker("git_diff", {}), desc = "Diff" },
      { "<leader>bb", fzf_lua_picker("buffers", {}), desc = "List buffers" },
      {
        "<leader>sw",
        function()
          local start_pos = vim.fn.getpos("v")
          local end_pos = vim.fn.getpos(".")
          local start_row, start_col = (start_pos[2] or 1) - 1, (start_pos[3] or 1) - 1
          local end_row, end_col = (end_pos[2] or 1) - 1, (end_pos[3] or 1)

          ---@cast start_row integer
          ---@cast start_col integer
          ---@cast end_row integer
          ---@cast end_col integer

          if start_row > end_row or (start_row == end_row and start_col > end_col) then
            start_row, end_row = end_row, start_row
            start_col, end_col = end_col, start_col
          end

          ---@cast start_row integer
          ---@cast start_col integer
          ---@cast end_row integer
          ---@cast end_col integer

          local lines = vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {})
          local text = table.concat(lines, "\n")
          if text == "" then
            return
          end
          fzf_lua_picker("grep_cword", { search = text })()
        end,
        mode = "v",
        desc = "Search selection",
      },
    },
    config = function()
      local fzf = require("fzf-lua")
      local config = fzf.config
      local actions = fzf.actions

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
        { "ivy" },
        fzf_bin = fzf_bin,
        fzf_colors = true,
        fzf_opts = {
          ["--no-scrollbar"] = true,
          ["--algo"] = "frizbee",
        },
        ui_select = function(fzf_opts, items)
          return vim.tbl_deep_extend("force", fzf_opts, {
            prompt = " ",
            winopts = {
              title = " " .. vim.trim((fzf_opts.prompt or "Select"):gsub("%s*:%s*$", "")) .. " ",
              title_pos = "center",
            },
          }, fzf_opts.kind == "codeaction" and {
            winopts = {
              layout = "vertical",
              -- height is number of items minus 15 lines for the preview, with a max of 80% screen height
              height = math.floor(math.min(vim.o.lines * 0.8 - 16, #items + 4) + 0.5) + 16,
              width = 0.5,
              preview = not vim.tbl_isempty(vim.lsp.get_clients({ bufnr = 0, name = "vtsls" })) and {
                layout = "vertical",
                vertical = "down:15,border-top",
                hidden = "hidden",
              } or {
                layout = "vertical",
                vertical = "down:15,border-top",
              },
            },
          } or {
            winopts = {
              width = 0.5,
              -- height is number of items, with a max of 80% screen height
              height = math.floor(math.min(vim.o.lines * 0.8, #items + 4) + 0.5),
            },
          })
        end,
        winopts = {
          width = 0.8,
          height = 0.8,
          row = 0.5,
          col = 0.5,
          preview = {
            scrollchars = { "┃", "" },
          },
        },
        files = {
          cwd_prompt = false,
          formatter = "path.filename_first",
          actions = {
            ["alt-i"] = { actions.toggle_ignore },
            ["alt-h"] = { actions.toggle_hidden },
          },
        },
        grep = {
          actions = {
            ["alt-i"] = { actions.toggle_ignore },
            ["alt-h"] = { actions.toggle_hidden },
          },
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
    "otavioschwanck/fzf-lua-enchanted-files",
    vscode = false,
    event = "VeryLazy",
    dependencies = { "ibhagwan/fzf-lua" },
    keys = {
      {
        "<leader><space>",
        function()
          require("fzf-lua-enchanted-files").files()
        end,
        desc = "Find files (frecency)",
      },
    },
    config = function()
      vim.g.fzf_lua_enchanted_files = {
        max_history_per_cwd = 50,
        auto_history = true,
        history_file = vim.fn.stdpath("data") .. "/fzf-lua-enchanted-files-history.json",
      }
    end,
  },
  {
    "folke/snacks.nvim",
    vscode = false,
    priority = 1000,
    lazy = false,
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
              action = ":lua require('fzf-lua-enchanted-files').files()",
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
  },
}
