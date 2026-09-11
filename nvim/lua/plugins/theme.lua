if vim.g.vscode then
  return
end

vim.pack.add({ Config.gh("thesimonho/kanagawa-paper.nvim"), Config.gh("webhooked/kanso.nvim") })

Config.now(function()
  require("kanagawa-paper").setup({
    -- enable undercurls for underlined text
    undercurl = true,
    -- transparent background
    transparent = false,
    -- highlight background for the left gutter
    gutter = false,
    -- background for diagnostic virtual text
    diag_background = false,
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

  require("kanso").setup({
    bold = true, -- enable bold fonts
    italics = true, -- enable italics
    compile = true, -- enable compiling the colorscheme
    undercurl = true, -- enable undercurls
    commentStyle = { italic = true },
    functionStyle = { bold = true, italic = true },
    keywordStyle = { italic = true },
    statementStyle = { bold = true },
    typeStyle = { italic = true },
    dimInactive = false,
    overrides = function(c)
      return {
        LspInlayHint = { fg = c.theme.syn.comment, bg = "NONE", italic = true },
        ["@string.documentation"] = { fg = c.theme.syn.comment, italic = true },
        ["@comment"] = { fg = c.theme.syn.comment, italic = true },
      }
    end,
  })

  vim.cmd.colorscheme("kanso")
end)
