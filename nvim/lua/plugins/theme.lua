return {
  { "folke/tokyonight.nvim", enabled = false },
  { "catppuccin/nvim", name = "catppuccin", enabled = false },
  {
    "everviolet/nvim",
    name = "evergarden",
    enabled = false,
    vscode = false,
    lazy = false,
    priority = 1000,
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
    "webhooked/kanso.nvim",
    enabled = false,
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

      -- vim.cmd.colorscheme("kanso")
    end,
  },
  {
    "thesimonho/kanagawa-paper.nvim",
    enabled = true,
    vscode = false,
    lazy = false,
    priority = 1000,
    config = function()
      local colors = require("kanagawa-paper.colors")
      local palette_colors = colors.palette
      require("kanagawa-paper").setup({
        -- enable undercurls for underlined text
        undercurl = true,
        -- transparent background
        transparent = false,
        -- highlight background for the left gutter
        gutter = false,
        -- background for diagnostic virtual text
        diag_background = true,
        -- dim inactive windows. Disabled when transparent
        dim_inactive = true,
        -- set colors for terminal buffers
        terminal_colors = true,
        -- cache highlights and colors for faster startup.
        -- see Cache section for more details.
        cache = true,

        styles = {
          -- style for comments
          comment = { italic = true },
          -- style for functions
          functions = { italic = true },
          -- style for keywords
          keyword = { italic = false, bold = true },
          -- style for statements
          statement = { italic = false, bold = true },
          -- style for types
          type = { italic = true },
        },
        -- override default palette and theme colors
        colors = {
          palette = {},
          theme = {
            ink = {
              syn = {
                member = palette_colors.dragonYellow,
              },
            },
            canvas = {},
          },
        },
        -- adjust overall color balance for each theme [-1, 1]
        color_offset = {
          ink = { brightness = 0, saturation = 0 },
          canvas = { brightness = 0, saturation = 0 },
        },

        -- uses lazy.nvim, if installed, to automatically enable needed plugins
        auto_plugins = true,
      })
    end,
  },
  {
    "killitar/obscure.nvim",
    enabled = false,
    vscode = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("obscure").setup({
        styles = {
          booleans = { italic = true, bold = true },
        },
      })
    end,
  },
}
