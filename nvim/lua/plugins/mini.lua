local mini_ai = require("utils.mini-ai")
local todo = require("utils.todo")

vim.pack.add({ Config.gh("nvim-mini/mini.nvim") })

Config.now(function()
  require("mini.pairs").setup()

  require("mini.surround").setup({
    mappings = {
      add = "gsa", -- Add surrounding in Normal and Visual modes
      delete = "gsd", -- Delete surrounding
      find = "gsf", -- Find surrounding (to the right)
      find_left = "gsF", -- Find surrounding (to the left)
      highlight = "gsh", -- Highlight surrounding
      replace = "gsr", -- Replace surrounding
    },
  })

  require("mini.move").setup({
    mappings = {
      -- Move visual selection in Visual mode.
      left = "<C-M-h>",
      right = "<C-M-l>",
      down = "<C-M-j>",
      up = "<C-M-k>",

      -- Move current line in Normal mode
      line_left = "<C-M-h>",
      line_right = "<C-M-l>",
      line_down = "<C-M-j>",
      line_up = "<C-M-k>",
    },
  })

  require("mini.operators").setup({
    evaluate = {
      prefix = "", -- disable default mapping
      -- Function which does the evaluation
      func = nil,
    },

    -- Exchange text regions
    exchange = {
      prefix = "", -- disable default mapping
      -- Whether to reindent new text to match previous indent
      reindent_linewise = true,
    },

    -- Multiply (duplicate) text
    multiply = {
      prefix = "gm",
      -- Function which can modify text before multiplying
      func = nil,
    },

    -- Replace text with register
    replace = {
      prefix = "gv",
      -- Whether to reindent new text to match previous indent
      reindent_linewise = true,
    },

    -- Sort text
    sort = {
      prefix = "gS",
      -- Function which does the sort
      func = nil,
    },
  })

  require("mini.comment").setup({
    -- Options which control module behavior
    options = {
      -- Function to compute custom 'commentstring' (optional)
      custom_commentstring = nil,

      -- Whether to ignore blank lines when commenting
      ignore_blank_line = false,

      -- Whether to ignore blank lines in actions and textobject
      start_of_line = false,

      -- Whether to force single space inner padding for comment parts
      pad_comment_parts = true,
    },

    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = {
      -- Toggle comment (like `gcip` - comment inner paragraph) for both
      -- Normal and Visual modes
      comment = "gc",

      -- Toggle comment on current line
      comment_line = "gcc",

      -- Toggle comment on visual selection
      comment_visual = "gc",

      -- Define 'comment' textobject (like `dgc` - delete whole comment block)
      -- Works also in Visual mode if mapping differs from `comment_visual`
      textobject = "gc",
    },

    -- Hook functions to be executed at certain stage of commenting
    hooks = {
      -- Before successful commenting. Does nothing by default.
      pre = function() end,
      -- After successful commenting. Does nothing by default.
      post = function() end,
    },
  })

  if not vim.g.vscode then
    require("mini.sessions").setup({
      autoread = false,
      autowrite = true,
      directory = vim.fn.stdpath("state") .. "/sessions/",
      file = "", -- no per-cwd `Session.vim` file, only the global dir above
      verbose = { read = true, write = true, delete = true },
    })

    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        if vim.g.minisessions_disable then
          return
        end
        local has_buffer = false
        for _, b in ipairs(vim.api.nvim_list_bufs()) do
          if vim.bo[b].buflisted then
            has_buffer = true
            break
          end
        end
        if has_buffer then
          require("mini.sessions").write(require("utils.session").name(), { force = true })
        end
      end,
    })

    require("mini.bufremove").setup({})

    require("mini.cmdline").setup({
      autocomplete = {
        enable = false,
      },
    })

    require("mini.indentscope").setup({
      symbol = "│",
      options = { try_as_border = true },
    })

    mini_ai.ai_setup()
    mini_ai.ai_whichkey()

    require("mini.icons").setup()
    require("mini.icons").mock_nvim_web_devicons()

    require("mini.hipatterns").setup({
      highlighters = {
        fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
        fix = { pattern = "%f[%w]()FIX()%f[%W]", group = "MiniHipatternsFixme" },
        hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
        todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
        note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
      },
    })

    require("mini.git").setup({})
    require("mini.diff").setup({
      view = {
        style = "sign",
      },
    })

    require("mini.tabline").setup({})

    require("mini.statuscolumn").setup()

    require("mini.notify").setup()
    require("mini.notify").make_notify()

    require("mini.input").setup({
      -- Default input scope: cursor/line/buffer/window/tabpage/editor/project
      scope = "cursor",
    })

    require("mini.starter").setup({
      header = table.concat({
        "  ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆",
        "  ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦",
        "        ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄",
        "          ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄",
        "        ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀",
        "  ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄",
        "⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄",
        "⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄",
        "⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄",
        "    ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆",
        "      ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃",
      }, "\n"),
      items = {
        { name = "Find File", action = "lua require('fzf-lua').files()", section = "Actions" },
        { name = "Grep Text", action = "lua require('fzf-lua').live_grep()", section = "Actions" },
        {
          name = "Session - Restore latest",
          action = function()
            require("utils.session").restore()
          end,
          section = "Actions",
        },
        {
          name = "Config",
          action = "lua require('fzf-lua').files({ cwd = vim.fn.stdpath('config') })",
          section = "Actions",
        },
        require("mini.starter").sections.builtin_actions(),
      },
      footer = function()
        return "⚡ Neovim loaded plugins via vim.pack"
      end,
      silent = true,
      evaluate_single = true,
    })
  end

  local map = vim.keymap.set
  -- Buffer
  map("n", "<leader>bd", function()
    require("mini.bufremove").delete(0, false)
  end, { desc = "Buffer Delete" })

  map("n", "<leader>bo", function()
    local cur = vim.api.nvim_get_current_buf()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if buf ~= cur and vim.bo[buf].buflisted then
        require("mini.bufremove").delete(buf, false)
      end
    end
  end, { desc = "Buffer Delete Others" })

  -- Jump todo
  map("n", "]t", todo.jump(true), { desc = "Next TODO comment" })
  map("n", "[t", todo.jump(false), { desc = "Prev TODO comment" })

  -- Notification
  map("n", "<leader>n", function()
    require("mini.notify").show_history()
  end, { desc = "Show history" })

  -- Git
  map("n", "<leader>gv", function()
    require("mini.diff").toggle_overlay()
  end, { desc = "Toggle Git changes" })
  map("n", "<leader>gb", function()
    require("mini.git").show_at_cursor()
  end, { desc = "Show history" })
  map("v", "<leader>gb", function()
    require("mini.git").show_range_history()
  end, { desc = "Show history" })

  -- Toggle
  map("n", "<leader>uf", function()
    vim.g.disable_autoformat = not vim.g.disable_autoformat
    vim.notify("Format on Save (global): " .. (vim.g.disable_autoformat and "off" or "on"))
  end, { desc = "Toggle Format on Save" })

  map("n", "<leader>uw", function()
    vim.wo.wrap = not vim.wo.wrap
    vim.notify("Wrap: " .. (vim.wo.wrap and "on" or "off"))
  end, { desc = "Toggle Wrap" })

  map("n", "<leader>uh", function()
    local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
    vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
    vim.notify("Inlay Hints: " .. (enabled and "off" or "on"))
  end, { desc = "Toggle Inlay Hints" })

  map("n", "<leader>ud", function()
    local enabled = vim.diagnostic.is_enabled()
    vim.diagnostic.enable(not enabled)
    vim.notify("Diagnostics: " .. (enabled and "off" or "on"))
  end, { desc = "Toggle Diagnostics" })

  -- Session
  map("n", "<leader>qs", function()
    require("utils.session").restore()
  end, { desc = "Restore Session" })

  map("n", "<leader>qS", function()
    require("mini.sessions").select("read")
  end, { desc = "Select Session" })

  map("n", "<leader>ql", function()
    require("mini.sessions").read(require("mini.sessions").get_latest())
  end, { desc = "Restore Last Session" })

  map("n", "<leader>qd", function()
    vim.g.minisessions_disable = true
    vim.notify("Session Save: off")
  end, { desc = "Disable Session Save" })
end)
