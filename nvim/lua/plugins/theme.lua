return {
  {
    "everviolet/nvim",
    name = "evergarden",
    vscode = false,
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
    vscode = false,
    lazy = true,
    -- priority = 1000,
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
          notify = true,
          rainbow_delimiters = true,
          telescope = true,
          treesitter = true,
        },
      })

      -- vim.cmd.colorscheme("oldworld")
    end,
  },
  {
    "webhooked/kanso.nvim",
    vscode = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("kanso").setup({
        bold = true, -- enable bold fonts
        italics = true, -- enable italics
        compile = true, -- enable compiling the colorscheme
        undercurl = true, -- enable undercurls
        commentStyle = { italic = true },
        functionStyle = { italic = true },
        keywordStyle = { italic = true },
        statementStyle = {},
        typeStyle = {},
        transparent = false, -- do not set background color
        dimInactive = true, -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        background = { -- map the value of 'background' option to a theme
          dark = "ink", -- try "zen", "mist" or "pearl" !
          light = "ink", -- try "zen", "mist" or "pearl" !
        },
        foreground = "saturated", -- "default" or "saturated" (can also be a table like background)
      })

      vim.cmd.colorscheme("kanso")
    end,
  },
}
