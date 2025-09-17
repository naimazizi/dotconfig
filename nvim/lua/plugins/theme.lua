return {
  {
    "everviolet/nvim",
    name = "evergarden",
    cond = not vim.g.vscode,
    lazy = true,
    -- priority = 1000,
    config = function()
      require("evergarden").setup({
        theme = {
          variant = "winter", -- 'winter'|'fall'|'spring'|'summer'
          accent = "green",
        },
        editor = {
          transparent_background = false,
        },
        integrations = {
          blink_cmp = true,
          gitsigns = true,
          indent_blankline = { enable = true, scope_color = "green" },
          mini = {
            enable = true,
            animate = true,
            clue = true,
            completion = true,
            cursorword = true,
            deps = true,
            diff = true,
            files = true,
            hipatterns = true,
            icons = true,
            indentscope = true,
            jump = true,
            jump2d = true,
            map = true,
            notify = true,
            operators = true,
            pick = true,
            starters = true,
            statusline = true,
            surround = true,
            tabline = true,
            test = true,
            trailspace = true,
          },
          rainbow_delimiters = true,
          symbols_outline = true,
          which_key = true,
        },
      })
      -- vim.cmd.colorscheme("evergarden")
    end,
  },
  {
    "dgox16/oldworld.nvim",
    cond = not vim.g.vscode,
    lazy = false,
    priority = 1000,
    config = function()
      require("oldworld").setup({
        terminal_colors = true, -- enable terminal colors
        variant = "default", -- default, oled, cooler
        styles = { -- You can pass the style using the format: style = true
          comments = { italic = true }, -- style for comments
          keywords = { bold = true }, -- style for keywords
          identifiers = {}, -- style for identifiers
          functions = { italic = true }, -- style for functions
          variables = {}, -- style for variables
          booleans = { bold = true }, -- style for booleans
        },
        integrations = { -- You can disable/enable integrations
          alpha = true,
          cmp = true,
          flash = true,
          gitsigns = true,
          indent_blankline = true,
          lazy = true,
          lsp = true,
          markdown = true,
          mason = true,
          noice = true,
          notify = true,
          rainbow_delimiters = true,
          telescope = true,
          treesitter = true,
        },
      })

      vim.cmd.colorscheme("oldworld")
    end,
  },
}
