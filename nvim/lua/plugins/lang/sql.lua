local sql_ft = { "sql", "mysql", "plsql" }

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
    "stevearc/conform.nvim",
    vscode = false,
    event = { "BufWritePre" },
    opts = function()
      conform = require("conform")
      conform.formatters.dawet_lint = {
        command = "dawet",
        args = function()
          return { "lint", "-m", vim.fn.expand("%:t:r") }
        end,
        cwd = require("conform.util").root_file({ "dawet_project.yml" }),
        require_cwd = true,
      }

      for _, ft in ipairs(sql_ft) do
        conform.formatters_by_ft[ft] = { "sqlfmt" }
        -- conform.formatters_by_ft[ft] = { "dawet_lint" } -- slow
      end
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
      for _, ft in ipairs(sql_ft) do
        lint.linters_by_ft[ft] = { "sqlfluff" }
      end
    end,
  },
}
