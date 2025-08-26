return {
  {
    "thesimonho/kanagawa-paper.nvim",
    cond = not vim.g.vscode,
    lazy = false,
    priority = 1000,
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
    "dgox16/oldworld.nvim",
    cond = not vim.g.vscode,
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("oldworld")
    end,
  },
}
