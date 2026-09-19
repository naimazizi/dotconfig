if vim.g.vscode then
  return
end

vim.pack.add({ Config.gh("thesimonho/kanagawa-paper.nvim"), Config.gh("ilof2/posterpole.nvim") })

Config.now(function()
  require("kanagawa-paper").setup({
    -- enable undercurls for underlined text
    undercurl = true,
    -- transparent background
    transparent = false,
    -- highlight background for the left gutter
    gutter = false,
    -- background for diagnostic virtual text diag_background = false,
    -- dim inactive windows. Disabled when transparent
    dim_inactive = false,
    -- set colors for terminal buffers
    terminal_colors = false,
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
            member = require("kanagawa-paper.colors").palette.dragonYellow,
          },
        },
        canvas = {},
      },
    },

    overrides = function(c)
      return {
        LspInlayHint = { fg = c.theme.syn.comment, bg = "NONE", italic = true },
        ["@string.documentation"] = { fg = c.theme.syn.comment, italic = true },
        ["@comment"] = { fg = c.theme.syn.comment, italic = true },
      }
    end,

    all_plugins = package.loaded.lazy == nil,
  })

  require("posterpole").setup({
    transparent = false,
    dim_inactive = true, -- highlight inactive splits
    custom_groups = {
      posterpole = {
        ["@string.documentation"] = { link = "Comment" },
        ["@pythonString"] = { link = "Comment" },
      },
    },
    lualine = {
      transparent = true,
    },
  })

  vim.cmd.colorscheme("posterpole")
end)
