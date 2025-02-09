return {
  {
    "stevearc/oil.nvim",
    event = "VeryLazy", -- Load the plugin lazy
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      default_file_explorer = false,
    },
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
  },
}
