return {
  "Vigemus/iron.nvim",
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
    "<localleader>sc",
    "<localleader>sc",
    "<localleader>sf",
    "<localleader>sl",
    "<localleader>su",
    "<localleader>sm",
    "<localleader>mc",
    "<localleader>mc",
    "<localleader>md",
    "<localleader>s<cr>",
    "<localleader>s<localleader>",
    "<localleader>sq",
    "<localleader>cl",
    { "<localleader>rs", "<cmd>IronRepl<cr>" },
    { "<localleader>rf", "<cmd>IronFocus<cr>" },
    { "<localleader>rh", "<cmd>IronHide<cr>" },
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
        },
      },
      -- How the repl window will be displayed
      -- See below for more information
      repl_open_cmd = "vertical botright 40 split",
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
      mark_motion = "<localleader>mc",
      mark_visual = "<localleader>mc",
      remove_mark = "<localleader>md",
      cr = "<localleader>s<cr>",
      interrupt = "<localleader>s<localleader>",
      exit = "<localleader>sq",
      clear = "<localleader>cl",
    },
    -- If the highlight is on, you can change how it looks
    -- For the available options, check nvim_set_hl
    highlight = { italic = true },
    ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
  },
}
