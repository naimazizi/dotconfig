return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters.sqruff = {
        args = { "fix", "--force" },
      }
      opts.formatters_by_ft = {
        sql = { "sqruff" },
      }
    end,
  },
}
