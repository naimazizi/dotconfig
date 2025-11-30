return {
  {
    "kndndrj/nvim-dbee",
    event = "VeryLazy",
    vscode = false,
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    build = function()
      require("dbee").install()
    end,
    config = function()
      require("dbee").setup( --[[optional config]])
    end,
  },
  {
    "mfussenegger/nvim-lint",
    vscode = false,
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      lint = require("lint")
      ---@diagnostic disable-next-line: inject-field
      lint.linters_by_ft = lint.linters_by_ft or {}
      for _, ft in ipairs(vim.g.sql_ft) do
        lint.linters_by_ft[ft] = { "sqlfluff" }
      end
    end,
  },
}
