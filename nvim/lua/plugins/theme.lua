return {
  {
    "thesimonho/kanagawa-paper.nvim",
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

      -- enable integrations with other applications
      integrations = {
        -- automatically set wezterm theme to match the current neovim theme
        wezterm = {
          enabled = true,
          -- neovim will write the theme name to this file
          -- wezterm will read from this file to know which theme to use
          path = (os.getenv("TEMP") or "/tmp") .. "/nvim-theme",
        },
      },
    },
  },
  {
    "vague2k/vague.nvim",
    config = function()
      require("vague").setup({
        transparent = false, -- don't set background
        style = {
          -- "none" is the same thing as default. But "italic" and "bold" are also valid options
          boolean = "bold",
          number = "none",
          float = "none",
          error = "bold",
          comments = "italic",
          conditionals = "none",
          functions = "none",
          headings = "bold",
          operators = "none",
          strings = "italic",
          variables = "none",

          -- keywords
          keywords = "none",
          keyword_return = "italic",
          keywords_loop = "none",
          keywords_label = "none",
          keywords_exception = "none",

          -- builtin
          builtin_constants = "bold",
          builtin_functions = "none",
          builtin_types = "bold",
          builtin_variables = "none",
        },
        -- plugin styles where applicable
        -- make an issue/pr if you'd like to see more styling options!
        plugins = {
          cmp = {
            match = "bold",
            match_fuzzy = "bold",
          },
          dashboard = {
            footer = "italic",
          },
          lsp = {
            diagnostic_error = "bold",
            diagnostic_hint = "none",
            diagnostic_info = "italic",
            diagnostic_warn = "bold",
          },
          neotest = {
            focused = "bold",
            adapter_name = "bold",
          },
          telescope = {
            match = "bold",
          },
        },
      })
    end,
  },
}
