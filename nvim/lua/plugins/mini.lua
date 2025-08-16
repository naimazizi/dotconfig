local function substitute_with_ssd(input_str)
  return input_str:gsub("^/Volumes/ADATA%-LEGEND%-960%-MAX/", "~/ssd/")
end

local function get_relative_filename()
  return substitute_with_ssd(vim.fn.expand("%:."))
end

local function get_cwd()
  return substitute_with_ssd(vim.fn.fnamemodify(vim.fn.getcwd(), ":~"))
end

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
        require("mini.starter").setup({
          -- Whether to open starter buffer on VimEnter. Not opened if Neovim was
          -- started with intent to show something else.
          autoopen = true,

          -- Whether to evaluate action of single active item
          evaluate_single = false,

          -- Items to be displayed. Should be an array with the following elements:
          -- - Item: table with <action>, <name>, and <section> keys.
          -- - Function: should return one of these three categories.
          -- - Array: elements of these three types (i.e. item, array, function).
          -- If `nil` (default), default items will be used (see |mini.starter|).
          items = nil,

          -- Header to be displayed before items. Converted to single string via
          -- `tostring` (use `\n` to display several lines). If function, it is
          -- evaluated first. If `nil` (default), polite greeting will be used.
          header = nil,

          -- Footer to be displayed after items. Converted to single string via
          -- `tostring` (use `\n` to display several lines). If function, it is
          -- evaluated first. If `nil` (default), default usage help will be shown.
          footer = nil,

          -- Array  of functions to be applied consecutively to initial content.
          -- Each function should take and return content for 'Starter' buffer (see
          -- |mini.starter| and |MiniStarter.content| for more details).
          content_hooks = nil,

          -- Characters to update query. Each character will have special buffer
          -- mapping overriding your global ones. Be careful to not add `:` as it
          -- allows you to go into command mode.
          query_updaters = "abcdefghijklmnopqrstuvwxyz0123456789_-.",

          -- Whether to disable showing non-error feedback
          silent = false,
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
              local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
              local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
              ---@diagnostic disable-next-line: unused-local
              local filename = MiniStatusline.section_filename({ trunc_width = 140 })
              local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
              local location = MiniStatusline.section_location({ trunc_width = 75 })
              local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

              return MiniStatusline.combine_groups({
                { hl = mode_hl, strings = { string.upper(mode) } },
                { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
                "%<", -- Mark general truncate point
                { hl = "MiniStatuslineFilename", strings = { get_relative_filename() } },
                "%=", -- End left alignment
                { hl = "MacroSlots", strings = { require("recorder").displaySlots() } },
                { hl = "MacroStatus", strings = { require("recorder").recordingStatus() } },
                { hl = "MiniStatuslineFilename", strings = { get_cwd() } },
                { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
                { hl = mode_hl, strings = { search, location } },
              })
            end,
          },
        })
      end
    end,
  },
}
