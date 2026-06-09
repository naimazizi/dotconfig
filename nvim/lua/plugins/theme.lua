return {
  {
    "thesimonho/kanagawa-paper.nvim",
    enabled = true,
    vscode = false,
    lazy = false,
    priority = 1000,
    opts = function()
      local palette_colors = require("kanagawa-paper.colors").palette
      return {
        -- enable undercurls for underlined text
        undercurl = true,
        -- transparent background
        transparent = false,
        -- highlight background for the left gutter
        gutter = false,
        -- background for diagnostic virtual text
        diag_background = true,
        -- dim inactive windows. Disabled when transparent
        dim_inactive = false,
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

        overrides = function(c)
          return {
            LspInlayHint = { fg = c.theme.syn.comment, bg = "NONE", italic = true },
            ["@string.documentation"] = { fg = c.theme.syn.comment, italic = true },
            ["@comment"] = { fg = c.theme.syn.comment, italic = true },
          }
        end,

        -- uses lazy.nvim, if installed, to automatically enable needed plugins
        auto_plugins = true,
      }
    end,
    config = function(_, opts)
      require("kanagawa-paper").setup(opts)
      vim.cmd.colorscheme("kanagawa-paper")
    end,
  },
}
