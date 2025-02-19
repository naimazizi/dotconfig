return {
  {
    "thesimonho/kanagawa-paper.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      undercurl = true,
      transparent = true,
      gutter = true,
      dimInactive = true, -- disabled when transparent
      terminalColors = true,
      commentStyle = { italic = true },
      functionStyle = { italic = true },
      keywordStyle = { italic = false, bold = false },
      statementStyle = { italic = false, bold = true },
      typeStyle = { italic = true },
      colors = { theme = {}, palette = {} }, -- override default palette and theme colors
      overrides = function() -- override highlight groups
        return {}
      end,
    },
  },
  {
    "ramojus/mellifluous.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "comfysage/evergarden",
    priority = 1000, -- Colorscheme plugin is loaded first before any other plugins
    opts = {
      transparent_background = true,
      variant = "hard", -- 'hard'|'medium'|'soft'
      overrides = {}, -- add custom overrides
    },
  },
}
