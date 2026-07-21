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
            -- WinBuf (winbuf.nvim) — per-window buffer tabs
            WinBufActive = { fg = c.theme.ui.fg, bg = c.theme.ui.bg_p2, bold = true },
            WinBufActiveSep = { fg = c.theme.ui.special, bg = c.theme.ui.bg_p2 },
            WinBufInactive = { fg = c.theme.ui.fg_dim, bg = c.theme.ui.bg_p1 },
            WinBufInactiveSep = { fg = c.theme.ui.bg_p2, bg = c.theme.ui.bg_p1 },
            WinBufActiveClose = { fg = c.theme.syn.special1, bg = c.theme.ui.bg_p2 },
            WinBufInactiveClose = { fg = c.theme.ui.fg_dim, bg = c.theme.ui.bg_p1 },
            WinBufActiveModified = { fg = c.theme.syn.string, bg = c.theme.ui.bg_p2 },
            WinBufInactiveModified = { fg = c.theme.ui.fg_dim, bg = c.theme.ui.bg_p1 },
            WinBufActiveDiagError = { fg = c.theme.diag.error, bg = c.theme.ui.bg_p2, bold = true },
            WinBufActiveDiagWarn = { fg = c.theme.diag.warning, bg = c.theme.ui.bg_p2 },
            WinBufInactiveDiagError = { fg = c.theme.diag.error, bg = c.theme.ui.bg_p1 },
            WinBufInactiveDiagWarn = { fg = c.theme.diag.warning, bg = c.theme.ui.bg_p1 },
            WinBufFill = { fg = c.theme.ui.fg_dim, bg = c.theme.ui.bg },
            WinBufActiveUnderline = { fg = c.theme.ui.fg_dim, bg = c.theme.ui.bg },
          }
        end,

        -- uses lazy.nvim, if installed, to automatically enable needed plugins
        auto_plugins = true,
      }
    end,
    config = function(_, opts)
      require("kanagawa-paper").setup(opts)
      vim.cmd.colorscheme("kanagawa-paper")

      local kanagawa_paper = require("lualine.themes.kanagawa-paper-ink")
      require("lualine").setup({
        options = {
          theme = kanagawa_paper,
        },
      })
    end,
  },
}
