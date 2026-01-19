return {
  {
    "thesimonho/kanagawa-paper.nvim",
    enabled = false,
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
        transparent = true,
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

      vim.cmd.colorscheme("kanagawa-paper")
    end,
  },
  {
    "ilof2/posterpole.nvim",
    enabled = true,
    vscode = false,
    lazy = false,
    priority = 1000,
    config = function()
      local posterpole = require("posterpole")

      posterpole.setup({
        transparent = true,
        dim_inactive = false,
      })
      vim.cmd("colorscheme posterpole")
    end,
  },
}
