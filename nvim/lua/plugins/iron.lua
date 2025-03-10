return {
  "Vigemus/iron.nvim",
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
    { "<localleader>sc", mode = { "n" }, desc = "Iron - Send Motion to Repl" },
    { "<localleader>sc", mode = { "v" }, desc = "Iron - Send Visual to Repl" },
    { "<localleader>sf", desc = "Iron - Send File to Repl" },
    { "<localleader>sl", desc = "Iron - Send Current Line to Repl" },
    { "<localleader>su", desc = "Iron - Send start until cursor to Repl" },
    { "<localleader>sm", desc = "Iron - Send mark to Repl" },
    { "<localleader>sb", desc = "Iron - Send code block to Repl" },
    { "<localleader>sn", desc = "Iron - Send code block and move to Repl" },
    { "<localleader>sq", desc = "Iron - Mark Motion" },
    { "<localleader>sq", desc = "Iron - Mark Visual" },
    { "<localleader>sd", desc = "Iron - Delete Mark" },
    { "<localleader>s<cr>", desc = "Iron - Send new line" },
    { "<localleader>s<localleader>", desc = "Iron - Interrupt Iron Repl" },
    { "<localleader>sq", desc = "Iron - Exit Iron Repl" },
    { "<localleader>sz", desc = "Iron - Clear Iron Repl" },
    { "<localleader>si", "<cmd>IronRepl<cr>", desc = "Iron - Start Iron Repl" },
    { "<localleader>sf", "<cmd>IronFocus<cr>", desc = "Iron - Focus to Iron Repl" },
    { "<localleader>sh", "<cmd>IronHide<cr>", desc = "Iron - Hide Iron Repl" },
  },
  main = "iron.core", -- <== This informs lazy.nvim to use the entrypoint of `iron.core` to load the configuration.
  opts = {
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
          block_deviders = { "# %%", "#%%" },
        },
        quarto = {
          command = { "ipython", "--no-autoindent" },
          block_deviders = { "# %%", "#%%" },
        },
      },
      -- How the repl window will be displayed
      -- See below for more information
      repl_open_cmd = "vertical botright 60 split",
    },
    -- Iron doesn't set keymaps by default anymore.
    -- You can set them here or manually add keymaps to the functions in iron.core
    keymaps = {
      send_motion = "<localleader>sc",
      visual_send = "<localleader>sc",
      send_file = "<localleader>sf",
      send_line = "<localleader>sl",
      send_until_cursor = "<localleader>su",
      send_mark = "<localleader>sm",
      send_code_block = "<localleader>sb",
      send_code_block_and_move = "<localleader>sn",
      mark_motion = "<localleader>sq",
      mark_visual = "<localleader>sq",
      remove_mark = "<localleader>sd",
      cr = "<localleader>s<cr>",
      interrupt = "<localleader>s<localleader>",
      exit = "<localleader>sq",
      clear = "<localleader>sz",
    },
    -- If the highlight is on, you can change how it looks
    -- For the available options, check nvim_set_hl
    highlight = { italic = true },
    ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
  },
}
