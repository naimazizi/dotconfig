return {
  -- Disable pyrola for now, image is not working properly
  -- {
  --   "matarina/pyrola.nvim",
  --   dependencies = { "nvim-treesitter/nvim-treesitter" },
  --   build = ":UpdateRemotePlugins",
  --   config = function(_, opts)
  --     local pyrola = require("pyrola")
  --     pyrola.setup({
  --       kernel_map = { -- Map Jupyter kernel names to Neovim filetypes
  --         python = "python3",
  --         r = "ir",
  --         cpp = "xcpp14",
  --       },
  --       split_horizen = false, -- Define the terminal split direction
  --       split_ratio = 0.3, -- Set the terminal split size
  --     })
  --
  --     -- Define key mappings for enhanced functionality
  --     vim.keymap.set("n", "<localleader>rs", function()
  --       pyrola.send_statement_definition()
  --     end, { noremap = true, desc = "Pyrola - Send the current line" })
  --
  --     vim.keymap.set("v", "<localleader>rs", function()
  --       require("pyrola").send_visual_to_repl()
  --     end, { noremap = true, desc = "Pyrola - Send the visual selection" })
  --
  --     vim.keymap.set("n", "<localleader>rw", function()
  --       pyrola.inspect()
  --     end, { noremap = true, desc = "Pyrola - Inspect the current line in the REPL" })
  --
  --     -- Configure Treesitter for enhanced code parsing
  --     require("nvim-treesitter.configs").setup({
  --       ensure_installed = { "cpp", "r", "python" }, -- Ensure the necessary Treesitter language parsers are installed
  --       auto_install = true,
  --     })
  --   end,
  -- },
  {
    "jpalardy/vim-slime",
    keys = {
      { "<localleader>sC", "<cmd>SlimeConfig<cr>", desc = "Slime Config" },
      { "<localleader>ss", "<Plug>SlimeSendCell<BAR>/^# %%<CR>", desc = "Slime Send Cell" },
      { "<localleader>ss", ":<C-u>'<,'>SlimeSend<CR>", mode = "v", desc = "Slime Send Selection" },
    },
    config = function()
      vim.g.slime_target = "zellij"
      vim.g.slime_cell_delimiter = "# %%"
      vim.g.slime_bracketed_paste = 1
    end,
  },
  {
    "benlubas/molten-nvim",
    event = "VeryLazy",
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 500
      vim.g.molten_auto_open_output = true
      vim.g.molten_virt_text_output = false
      vim.g.molten_wrap_output = true
      vim.keymap.set(
        "n",
        "<localleader>mi",
        ":MoltenInit<CR>",
        { silent = true, desc = "Molten - Initialize the plugin" }
      )
      vim.keymap.set(
        "n",
        "<localleader>mw",
        ":MoltenEvaluateOperator<CR>",
        { silent = true, desc = "Molten - Run operator selection" }
      )
      vim.keymap.set(
        "n",
        "<localleader>me",
        ":MoltenEvaluateLine<CR>",
        { silent = true, desc = "Molten - Evaluate line" }
      )
      vim.keymap.set(
        "n",
        "<localleader>mr",
        ":MoltenReevaluateCell<CR>",
        { silent = true, desc = "Molten - Re-evaluate cell" }
      )
      vim.keymap.set(
        "v",
        "<localleader>me",
        ":<C-u>MoltenEvaluateVisual<CR>gv",
        { silent = true, desc = "Molten - Evaluate visual selection" }
      )
      vim.keymap.set("n", "<localleader>md", ":MoltenDelete<CR>", { silent = true, desc = "Molten - Delete cell" })
      vim.keymap.set("n", "<localleader>mh", ":MoltenHideOutput<CR>", { silent = true, desc = "Molten - Hide output" })
      vim.keymap.set(
        "n",
        "<localleader>ms",
        ":noautocmd MoltenEnterOutput<CR>",
        { silent = true, desc = "Molten - Show/enter output" }
      )
      vim.keymap.set(
        "n",
        "<localleader>mn",
        ":noautocmd MoltenNext<CR>",
        { silent = true, desc = "Molten - Go to Next Cell" }
      )
      vim.keymap.set(
        "n",
        "<localleader>mN",
        ":noautocmd MoltenNext<CR>",
        { silent = true, desc = "Molten - Go to Previous Cell" }
      )
    end,
  },
  {
    "GCBallesteros/NotebookNavigator.nvim",
    dependencies = {
      "echasnovski/mini.comment",
      "benlubas/molten-nvim",
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
      { "<localleader>rs", mode = { "n" }, desc = "Iron - Send Motion to Repl" },
      { "<localleader>rs", mode = { "v" }, desc = "Iron - Send Visual to Repl" },
      { "<localleader>rf", desc = "Iron - Send File to Repl" },
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
      { "<localleader>ri", "<cmd>IronRepl<cr>", desc = "Iron - Start Iron Repl" },
      { "<localleader>rf", "<cmd>IronFocus<cr>", desc = "Iron - Focus to Iron Repl" },
      { "<localleader>rh", "<cmd>IronHide<cr>", desc = "Iron - Hide Iron Repl" },
    },
    main = "iron.core", -- <== This informs lazy.nvim to use the entrypoint of `iron.core` to load the configuration.
    config = function(_, opts)
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
