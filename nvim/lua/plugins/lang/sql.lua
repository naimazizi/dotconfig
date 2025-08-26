local sql_ft = { "sql", "mysql", "plsql" }

return {
  {
    "kndndrj/nvim-dbee",
    event = "VeryLazy",
    cond = not vim.g.vscode,
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
    cond = not vim.g.vscode,
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
    cond = not vim.g.vscode,
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      lint = require("lint")
      lint.linters_by_ft = lint.linters_by_ft or {}
      for _, ft in ipairs(sql_ft) do
        lint.linters_by_ft[ft] = { "sqlfluff" }
      end
    end,
  },
}
