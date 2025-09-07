return {
  {
    "everviolet/nvim",
    name = "evergarden",
    cond = not vim.g.vscode,
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
      vim.cmd.colorscheme("evergarden")
    end,
  },
}
