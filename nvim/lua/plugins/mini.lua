return {
  {
    "nvim-mini/mini.nvim",
    config = function()
      require("mini.surround").setup({
        mappings = {
          add = "gsa", -- Add surrounding in Normal and Visual modes
          delete = "gsd", -- Delete surrounding
          find = "gsf", -- Find surrounding (to the right)
          find_left = "gsF", -- Find surrounding (to the left)
          highlight = "gsh", -- Highlight surrounding
          replace = "gsr", -- Replace surrounding
          update_n_lines = "gsn", -- Update `n_lines`
        },
      })

      require("mini.pairs").setup()

      require("mini.align").setup()

      require("mini.move").setup()

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
        starter = require("mini.starter")

        local logo = [[
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣴⡿⠟⠛⠋⠉⠉⢩⣍⠛⠛⠿⣷⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⠿⠋⠁⠀⠀⠀⠀⠀⠀⣿⣿⠀⣰⡄⠈⠻⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⡿⠟⠁⢀⣠⣤⣀⣀⣀⣴⣿⣿⣿⣿⣿⣿⣿⡆⠀⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⡿⠋⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠞⠛⠛⢿⣿⣶⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⠿⠿⠿⠿⠟⠋⠁⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢀⣠⣾⠟⠋⠀⠀⠀⠀⠈⢿⣿⣿⠿⣿⠏⣸⡿⠁⣿⠟⠉⣿⣿⣠⣴⣤⣀⣀⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⢀⣀⣠⣤⣾⠿⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣤⡞⠀⡿⠁⣴⠃⣠⡾⢿⣿⣿⣿⣿⣿⡿⠋⣠⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠻⠛⠋⠉⠀⠀⣠⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣷⣴⣧⣼⡏⢰⡏⠀⣼⣿⠿⠿⢿⣿⣇⢰⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⢿⣿⡛⠻⣷⡄⠀⠀⣼⣿⡿⠃⣠⣿⣿⣿⣿⣷⣿⠀⣼⡟⠁⠀⠀⢀⠘⢿⣿⣿⣿⠿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡾
⠀⢀⣴⣶⣶⣦⣄⡀⣹⣿⣾⠟⠿⡆⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿⠀⣿⡇⠀⠀⠀⢿⡿⢸⣿⣿⣥⣤⣼⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⠟⠁
⢠⣿⣿⣿⣿⣿⣿⣿⡿⢿⣿⣷⣶⣿⣦⣈⠙⣻⣿⣿⣿⣿⣿⣿⡀⢿⡆⣿⡇⠀⠀⠀⠀⠀⠘⠿⠿⠟⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⠟⠁⠀⠀
⠸⣿⣿⣿⣿⣿⣿⣿⣇⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡘⢿⣿⣿⡄⠀⠀⠀⢠⣴⣷⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⠟⠁⠀⠀⢠⡿
⠀⢿⣿⣿⡿⠻⣿⣿⣿⣿⣌⠻⣯⠻⣿⣿⣿⣿⡿⠟⠉⠀⠀⠀⠉⠻⣿⣿⣿⣿⣦⡀⠀⠘⢿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣾⠟⠁⠀⠀⠀⣰⠿⣷
⠀⠈⠻⣿⣷⣤⣿⣿⣿⣿⣿⣷⣼⣿⣾⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣶⡿⠋⠀⠀⢀⣠⣴⣿⢿⣦⣤
⠀⠀⠀⠘⠻⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⢿⣿⣿⣶⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣴⣾⡿⠛⠁⠀⠀⢀⣴⣿⣿⣿⣿⣾⠟⠉
⠀⠀⠀⠀⠀⠀⠉⠛⠛⠛⠛⠋⠁⢀⡀⠀⠀⠀⠀⠀⢀⣤⣶⠀⠀⣀⣀⣀⡀⠀⠀⢠⡈⠛⠻⠿⣿⣿⣿⣿⣷⣶⣶⣾⣿⣿⡿⠿⠛⠋⠁⠀⣴⣶⡾⠟⠋⢁⣀⣽⣿⠟⣡⣶⣿
    ]]
        logo = string.rep("\n", 8) .. logo .. "\n\n"
        starter.setup({
          -- Whether to open starter buffer on VimEnter. Not opened if Neovim was
          -- started with intent to show something else.
          autoopen = true,

          -- Whether to disable showing non-error feedback
          silent = false,

          content_hooks = {
            starter.gen_hook.adding_bullet("                        "),
            starter.gen_hook.aligning("center", "center"),
          },
          evaluate_single = true,
          footer = os.date(),
          header = logo,
          query_updaters = [[abcdefghilmoqrstuvwxyz0123456789_-,.ABCDEFGHIJKLMOQRSTUVWXYZ]],
          items = {
            {
              -- action = "lua Snacks.picker.files()",
              action = "lua require('fff').find_files()",
              name = "F: Find Files",
              section = "Builtin actions",
            },
            {
              action = "lua Snacks.picker.grep()",
              name = "R: Grep (Find text)",
              section = "Builtin actions",
            },
            {
              action = "lua Snacks.picker.todo_comments()",
              name = "T: Todos",
              section = "Builtin actions",
            },
            {
              action = "lua require('persistence').load()",
              name = "S: Restore Last Session",
              section = "Builtin actions",
            },
            {
              action = "enew",
              name = "E: New Buffer",
              section = "Builtin actions",
            },
            {
              action = "lua Snacks.picker.projects()",
              name = "W: Workspaces",
              section = "Builtin actions",
            },
            {
              action = "qall!",
              name = "Q: Quit Neovim",
              section = "Builtin actions",
            },
            {
              action = "lua Snacks.lazygit()",
              name = "G: Lazgit",
              section = "Git",
            },
            { action = "Lazy", name = "L: Lazy", section = "Plugins" },
            { action = "Mason", name = "M: Mason", section = "Plugins" },
          },
        })

        require("mini.icons").setup()
      end
    end,
  },
}
