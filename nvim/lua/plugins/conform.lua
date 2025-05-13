return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters.sqruff = {
        args = { "fix", "--force", "$FILENAME" },
      }
      opts.formatters_by_ft = {
        sql = { "sqlfmt" },
      }
    end,
  },
}
