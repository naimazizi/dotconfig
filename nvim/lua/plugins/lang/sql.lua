local sql_ft = { "sql", "mysql", "plsql" }

return {
  -- {
  --   "kndndrj/nvim-dbee",
  --   event = "VeryLazy",
  --   cond = not vim.g.vscode,
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --   },
  --   build = function()
  --     require("dbee").install()
  --   end,
  --   config = function()
  --     require("dbee").setup( --[[optional config]])
  --   end,
  -- },
  {
    "stevearc/conform.nvim",
    optional = true,
    cond = not vim.g.vscode,
    opts = function(_, opts)
      opts.formatters.sqlfluff = {
        args = { "format", "--dialect=ansi", "-" },
        cwd = function()
          return vim.fn.getcwd()
        end,
      }

      opts.formatters.dawet_lint = {
        command = "dawet",
        args = function()
          return { "lint", "-m", vim.fn.expand("%:t:r") }
        end,
        cwd = require("conform.util").root_file({ "dawet_project.yml" }),
        require_cwd = true,
      }

      for _, ft in ipairs(sql_ft) do
        opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
        -- table.insert(opts.formatters_by_ft[ft], "dawet_lint") -- slow as hell
        table.insert(opts.formatters_by_ft[ft], "sqlfmt")
      end
    end,
  },
  {
    "mfussenegger/nvim-lint",
    cond = not vim.g.vscode,
    optional = true,
    opts = function(_, opts)
      for _, ft in ipairs(sql_ft) do
        opts.linters_by_ft[ft] = opts.linters_by_ft[ft] or {}
        table.insert(opts.linters_by_ft[ft], "sqlfluff")
      end
    end,
  },
}
