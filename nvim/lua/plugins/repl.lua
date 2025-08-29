return {
  {
    "GCBallesteros/NotebookNavigator.nvim",
    cond = not vim.g.vscode,
    dependencies = {
      "nvim-mini/mini.comment",
    },
    event = "VeryLazy",
    config = function()
      local nn = require("notebook-navigator")
      vim.keymap.set({ "n", "v" }, "[3", function()
        nn.move_cell("u")
      end, { silent = true, desc = "Notebook - Move cell up" })
      vim.keymap.set({ "n", "v" }, "]3", function()
        nn.move_cell("d")
      end, { silent = true, desc = "Notebook - Move cell down" })
    end,
  },
  {
    "Vigemus/iron.nvim",
    cond = not vim.g.vscode,
    event = "VeryLazy",
    cmd = {
      "IronRepl",
      "IronReplHere",
      "IronRestart",
      "IronSend",
      "IronFocus",
      "IronHide",
      "IronWatch",
      "IronAttach",
    },
    keys = {
      { "<localleader>rt", desc = "Iron - Toggle Repl" },
      { "<localleader>re", desc = "Iron - Send Current Line to Repl" },
      { "<localleader>ru", desc = "Iron - Send start until cursor to Repl" },
      { "<localleader>rm", desc = "Iron - Send mark to Repl" },
      { "<localleader>rr", desc = "Iron - Send code block to Repl" },
      { "<localleader>rb", desc = "Iron - Send code block and move to Repl" },
      { "<localleader>rq", desc = "Iron - Mark Motion" },
      { "<localleader>rq", desc = "Iron - Mark Visual" },
      { "<localleader>rd", desc = "Iron - Delete Mark" },
      { "<localleader>r<cr>", desc = "Iron - Send new line" },
      { "<localleader>r<localleader>", desc = "Iron - Interrupt Iron Repl" },
      { "<localleader>rq", desc = "Iron - Exit Iron Repl" },
      { "<localleader>rz", desc = "Iron - Clear Iron Repl" },
      {
        "<localleader>ri",
        "<cmd>IronRepl<cr>",
        desc = "Iron - Start Iron Repl",
      },
      {
        "<localleader>rf",
        "<cmd>IronFocus<cr>",
        desc = "Iron - Focus to Iron Repl",
      },
      {
        "<localleader>rh",
        "<cmd>IronHide<cr>",
        desc = "Iron - Hide Iron Repl",
      },
    },
    main = "iron.core", -- <== This informs lazy.nvim to use the entrypoint of `iron.core` to load the configuration.
    config = function()
      require("which-key").add({
        { "<localleader>r", group = "+REPL", icon = "" },
        { "<localleader>rt", desc = "Iron - Toggle Repl" },
        { "<localleader>re", desc = "Iron - Send Current Line to Repl" },
        { "<localleader>ru", desc = "Iron - Send start until cursor to Repl" },
        { "<localleader>rm", desc = "Iron - Send mark to Repl" },
        { "<localleader>rr", desc = "Iron - Send code block to Repl" },
        { "<localleader>rb", desc = "Iron - Send code block and move to Repl" },
        { "<localleader>rq", desc = "Iron - Mark Motion" },
        { "<localleader>rq", desc = "Iron - Mark Visual" },
        { "<localleader>rd", desc = "Iron - Delete Mark" },
        { "<localleader>r<cr>", desc = "Iron - Send new line" },
        { "<localleader>r<localleader>", desc = "Iron - Interrupt Iron Repl" },
        { "<localleader>rq", desc = "Iron - Exit Iron Repl" },
        { "<localleader>rz", desc = "Iron - Clear Iron Repl" },
        {
          "<localleader>ri",
          desc = "Iron - Start Iron Repl",
        },
        {
          "<localleader>rf",
          desc = "Iron - Focus to Iron Repl",
        },
        {
          "<localleader>rh",
          desc = "Iron - Hide Iron Repl",
        },
        {
          "<localleader>rs",
          desc = "Iron - Send motion",
        },
      })

      local iron = require("iron")
      local common = require("iron.fts.common")
      iron.setup({
        config = {
          -- Whether a repl should be discarded or not
          scratch_repl = true,
          -- Your repl definitions come here
          repl_definition = {
            sh = {
              -- Can be a table or a function that
              -- returns a table (see below)
              command = { "fish" },
            },
            python = {
              command = { "ipython", "--no-autoindent" },
              format = common.bracketed_paste_python,
              block_dividers = { "# %%", "#%%" },
            },
            quarto = {
              command = { "ipython", "--no-autoindent" },
              format = common.bracketed_paste_python,
              block_dividers = { "# %%", "#%%" },
            },
          },
          -- How the repl window will be displayed
          -- See below for more information
          repl_open_cmd = "vertical botright 60 split",
        },
        keymaps = {
          toggle_repl = "<localleader>rt",
          send_motion = "<localleader>rs",
          visual_send = "<localleader>rs",
          send_file = "<localleader>rf",
          send_line = "<localleader>re",
          send_until_cursor = "<localleader>ru",
          send_mark = "<localleader>rm",
          send_code_block = "<localleader>rr",
          send_code_block_and_move = "<localleader>rb",
          mark_motion = "<localleader>rq",
          mark_visual = "<localleader>rq",
          remove_mark = "<localleader>rd",
          cr = "<localleader>r<cr>",
          interrupt = "<localleader>r<localleader>",
          exit = "<localleader>rq",
          clear = "<localleader>rz",
        },
        -- If the highlight is on, you can change how it looks
        -- For the available options, check nvim_set_hl
        highlight = { italic = true },
        ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
      })
    end,
  },
}
