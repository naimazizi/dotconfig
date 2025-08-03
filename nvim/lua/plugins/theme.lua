return {
  {
    "thesimonho/kanagawa-paper.nvim",
    lazy = false,
    priority = 1000,
    vscode = false,
    opts = {

      -- enable undercurls for underlined text
      undercurl = true,
      -- transparent background
      transparent = false,
      -- highlight background for the left gutter
      gutter = true,
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
        functions = { italic = false },
        -- style for keywords
        keyword = { italic = true, bold = false },
        -- style for statements
        statement = { italic = false, bold = true },
        -- style for types
        type = { italic = true },
      },
      -- uses lazy.nvim, if installed, to automatically enable needed plugins
      auto_plugins = true,
      -- enable highlights for all plugins (disabled if using lazy.nvim)
      all_plugins = package.loaded.lazy == nil,
      -- manually enable/disable individual plugins.
      -- check the `groups/plugins` directory for the exact names
      plugins = {
        -- examples:
        rainbow_delimiters = true,
        which_key = true,
        blink = true,
        snacks = true,
        trouble = true,
        yanky = true,
        nvim_dap_ui = true,
        nvim_navic = true,
        nvim_treesitter_context = true,
        noice = true,
        neotest = true,
        grug_far = true,
        overseer = true,
        mini = true,
      },
    },
  },
  {
    "webhooked/kanso.nvim",
    lazy = false,
    vscode = false,
    priority = 1000,
    config = function()
      -- Default options:
      require("kanso").setup({
        bold = true, -- enable bold fonts
        italics = true, -- enable italics
        compile = false, -- enable compiling the colorscheme
        undercurl = true, -- enable undercurls
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = {},
        typeStyle = {},
        transparent = false, -- do not set background color
        dimInactive = false, -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        colors = { -- add/modify theme and palette colors
          palette = {},
          theme = { zen = {}, pearl = {}, ink = {}, all = {} },
        },
        overrides = function(colors) -- add/modify highlights
          return {}
        end,
        background = { -- map the value of 'background' option to a theme
          dark = "ink",
          light = "mist",
        },
        foreground = "default", -- "default" or "contrast" (can also be a table like background)
      })
    end,
  },
}
