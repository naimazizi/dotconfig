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
      { "<localleader>ss", desc = "Iron - Toggle Repl" },
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
              block_deviders = { "# %%", "#%%" },
            },
            quarto = {
              command = { "ipython", "--no-autoindent" },
              format = common.bracketed_paste_python,
              block_deviders = { "# %%", "#%%" },
            },
          },
          -- How the repl window will be displayed
          -- See below for more information
          repl_open_cmd = "vertical botright 60 split",
        },
        keymaps = {
          toggle_repl = "<localleader>ss",
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
      })
    end,
  },
  {
    "michaelb/sniprun",
    event = "VeryLazy",
    branch = "master",
    build = "sh install.sh",
    config = function()
      require("sniprun").setup({
        selected_interpreters = { "Python3_jupyter" },
        repl_enable = { "Python3_jupyter" },

        vim.api.nvim_set_keymap(
          "v",
          "<localleader>rr",
          "<Plug>SnipRun",
          { silent = true, desc = "SnipRun - Run visual selection" }
        ),
        vim.api.nvim_set_keymap(
          "n",
          "<localleader>rr",
          "<Plug>SnipRun",
          { silent = true, desc = "SnipRun - Run current line" }
        ),
        vim.api.nvim_set_keymap(
          "n",
          "<localleader>rf",
          "<Plug>SnipRunOperator",
          { silent = true, desc = "SnipRun - Run operator selection" }
        ),
        vim.api.nvim_set_keymap("n", "<localleader>ri", "<Plug>SnipInfo", { silent = true, desc = "SnipRun - Info" }),
        vim.api.nvim_set_keymap(
          "n",
          "<localleader>rv",
          "<Plug>SnipLive",
          { silent = true, desc = "SnipRun - Live Mode Toggle" }
        ),
        vim.api.nvim_set_keymap("n", "<localleader>rq", "<Plug>SnipClose", { silent = true, desc = "SnipRun - Close" }),
        vim.api.nvim_set_keymap("n", "<localleader>rz", "<Plug>SnipReset", { silent = true, desc = "SnipRun - Reset" }),
      })
    end,
  },
  {
    "benlubas/molten-nvim",
    event = "VeryLazy",
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
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
    "kiyoon/jupynium.nvim",
    event = "VeryLazy",
    build = "uv pip install . --python=$HOME/.pyenv/versions/fs-lending/bin/python",
    config = function()
      require("jupynium").setup({
        --- For Conda environment named "jupynium",
        -- python_host = { "conda", "run", "--no-capture-output", "-n", "jupynium", "python" },
        python_host = vim.g.python3_host_prog or "python3",

        default_notebook_URL = "localhost:8888/nbclassic",

        -- Write jupyter command but without "notebook"
        -- When you call :JupyniumStartAndAttachToServer and no notebook is open,
        -- then Jupynium will open the server for you using this command. (only when notebook_URL is localhost)
        jupyter_command = "jupyter",
        --- For Conda, maybe use base environment
        --- then you can `conda install -n base nb_conda_kernels` to switch environment in Jupyter Notebook
        -- jupyter_command = { "conda", "run", "--no-capture-output", "-n", "base", "jupyter" },

        -- Used when notebook is launched by using jupyter_command.
        -- If nil or "", it will open at the git directory of the current buffer,
        -- but still navigate to the directory of the current buffer. (e.g. localhost:8888/nbclassic/tree/path/to/buffer)
        notebook_dir = nil,

        -- Used to remember the last session (password etc.).
        -- e.g. '~/.mozilla/firefox/profiles.ini'
        -- or '~/snap/firefox/common/.mozilla/firefox/profiles.ini'
        firefox_profiles_ini_path = nil,
        -- nil means the profile with Default=1
        -- or set to something like 'default-release'
        firefox_profile_name = nil,

        -- Open the Jupynium server if it is not already running
        -- which means that it will open the Selenium browser when you open this file.
        -- Related command :JupyniumStartAndAttachToServer
        auto_start_server = {
          enable = false,
          file_pattern = { "*.ju.*" },
        },

        -- Attach current nvim to the Jupynium server
        -- Without this step, you can't use :JupyniumStartSync
        -- Related command :JupyniumAttachToServer
        auto_attach_to_server = {
          enable = true,
          file_pattern = { "*.ju.*", "*.md" },
        },

        -- Automatically open an Untitled.ipynb file on Notebook
        -- when you open a .ju.py file on nvim.
        -- Related command :JupyniumStartSync
        auto_start_sync = {
          enable = false,
          file_pattern = { "*.ju.*", "*.md" },
        },

        -- Automatically keep filename.ipynb copy of filename.ju.py
        -- by downloading from the Jupyter Notebook server.
        -- WARNING: this will overwrite the file without asking
        -- Related command :JupyniumDownloadIpynb
        auto_download_ipynb = false,

        -- Automatically close tab that is in sync when you close buffer in vim.
        auto_close_tab = true,

        -- Always scroll to the current cell.
        -- Related command :JupyniumScrollToCell
        autoscroll = {
          enable = true,
          mode = "always", -- "always" or "invisible"
          cell = {
            top_margin_percent = 20,
          },
        },

        scroll = {
          page = { step = 0.5 },
          cell = {
            top_margin_percent = 20,
          },
        },

        -- Files to be detected as a jupynium file.
        -- Add highlighting, keybindings, commands (e.g. :JupyniumStartAndAttachToServer)
        -- Modify this if you already have lots of files in Jupytext format, for example.
        jupynium_file_pattern = { "*.ju.*" },

        use_default_keybindings = false,
        textobjects = {
          use_default_keybindings = true,
        },

        syntax_highlight = {
          enable = true,
        },

        -- Dim all cells except the current one
        -- Related command :JupyniumShortsightedToggle
        shortsighted = false,

        -- Configure floating window options
        -- Related command :JupyniumKernelHover
        kernel_hover = {
          floating_win_opts = {
            max_width = 84,
            border = "none",
          },
        },

        notify = {
          ignore = {
            -- "download_ipynb",
            -- "error_download_ipynb",
            -- "attach_and_init",
            -- "error_close_main_page",
            -- "notebook_closed",
          },
        },
        colorscheme = "tokyonight",
      })

      vim.keymap.set(
        { "n", "x" },
        "<localleader>jj",
        "<cmd>JupyniumExecuteSelectedCells<CR>",
        { desc = "Jupynium execute selected cells" }
      )
      vim.keymap.set(
        { "n", "x" },
        "<localleader>jc",
        "<cmd>JupyniumClearSelectedCellsOutputs<CR>",
        { desc = "Jupynium clear selected cells" }
      )
      vim.keymap.set(
        { "n" },
        "<localleader>jK",
        "<cmd>JupyniumKernelHover<cr>",
        { desc = "Jupynium hover (inspect a variable)" }
      )
      vim.keymap.set(
        { "n", "x" },
        "<localleader>js",
        "<cmd>JupyniumScrollToCell<cr>",
        { desc = "Jupynium scroll to cell" }
      )
      vim.keymap.set(
        { "n", "x" },
        "<localleader>jo",
        "<cmd>JupyniumToggleSelectedCellsOutputsScroll<cr>",
        { desc = "Jupynium toggle selected cell output scroll" }
      )
    end,
  },
}
