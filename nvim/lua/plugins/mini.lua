return {
  { -- Collection of various small independent plugins/modules
    "echasnovski/mini.nvim",
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require("mini.ai").setup({ n_lines = 500 })

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
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

      require("mini.comment").setup( -- No need to copy this inside `setup()`. Will be used automatically.
        {
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
        }
      )

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
              action = "lua Snacks.picker.files()",
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
              name = "P: Projects",
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

        local statusline = require("mini.statusline")

        statusline.section_location = function()
          return "%2l:%-2v"
        end

        statusline.setup({
          use_icons = vim.g.have_nerd_font,
          content = {
            -- Content for active window
            active = function()
              local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
              local git = MiniStatusline.section_git({ trunc_width = 40 })
              local diff = MiniStatusline.section_diff({ trunc_width = 75 })
              ---@diagnostic disable-next-line: unused-local
              local filename = MiniStatusline.section_filename({ trunc_width = 140 })
              local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
              local location = MiniStatusline.section_location({ trunc_width = 75 })
              local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

              return MiniStatusline.combine_groups({
                { hl = mode_hl, strings = { string.upper(mode) } },
                { hl = "MiniStatuslineDevinfo", strings = { git, diff } },
                "%<", -- Mark general truncate point
                { hl = "MiniStatuslineFilename", strings = { vim.fn.expand("%:.") } },
                "%=", -- End left alignment
                { hl = "MacroSlots", strings = { require("recorder").displaySlots() } },
                { hl = "MacroStatus", strings = { require("recorder").recordingStatus() } },
                { hl = "MiniStatuslineFilename", strings = { vim.fn.fnamemodify(vim.fn.getcwd(), ":~") } },
                { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
                { hl = mode_hl, strings = { search, location } },
              })
            end,
          },
        })

        require("mini.tabline").setup({
          show_icons = true,
          tabpage_section = "left",
        })

        require("mini.icons").setup()

        require("mini.move").setup()
      end
    end,
  },
}
