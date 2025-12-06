return {
  {
    "stevearc/conform.nvim",
    vscode = false,
    opts = function(_, opts)
      --Custom formatters
      opts.formatters.dawet_lint = {
        command = "dawet",
        args = function()
          return { "lint", "-m", vim.fn.expand("%:t:r") }
        end,
        cwd = require("conform.util").root_file({ "dawet_project.yml" }),
        require_cwd = true,
      }

      -- Markdown formatters
      for _, ft in ipairs(vim.g.md_ft) do
        opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
        table.insert(opts.formatters_by_ft[ft], "markdownlint-cli2")
      end

      -- Python formatters
      for _, ft in ipairs({ "python" }) do
        opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
        table.insert(opts.formatters_by_ft[ft], "ruff_format")
      end

      -- SQL formatters
      for _, ft in ipairs(vim.g.sql_ft) do
        opts.formatters_by_ft[ft] = { "sqlfmt" }
        -- opts.formatters_by_ft[ft] = { "dawet_lint" } -- slow
      end

      -- Lua formatter
      opts.formatters_by_ft["lua"] = { "stylua" }

      -- shell formatter
      for _, ft in ipairs(vim.g.sh_ft) do
        opts.formatters_by_ft[ft] = { "shfmt" }
      end

      -- json formatter
      opts.formatters_by_ft["json"] = { "jq" }

      -- kdl formatter
      opts.formatters_by_ft["kdl"] = { "kdlfmt" }

      -- Injected formatter for code blocks in markdown-like file
      for _, ft in ipairs(vim.g.md_injected_ft) do
        opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
        table.insert(opts.formatters_by_ft[ft], "injected")
      end
      -- Customize the "injected" formatter
      opts.formatters.injected = {
        -- Set the options field
        options = {
          -- Set to true to ignore errors
          ignore_errors = true,
          -- Map of treesitter language to file extension
          -- A temporary file name with this extension will be generated during formatting
          -- because some formatters care about the filename.
          lang_to_ext = {
            bash = "sh",
            c_sharp = "cs",
            elixir = "exs",
            javascript = "js",
            julia = "jl",
            latex = "tex",
            markdown = "md",
            python = "py",
            ruby = "rb",
            rust = "rs",
            teal = "tl",
            r = "r",
            typescript = "ts",
          },
          -- Map of treesitter language to formatters to use
          -- (defaults to the value from formatters_by_ft)
          lang_to_formatters = {},
        },
      }
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "markdownlint-cli2", "ruff", "stylua" } },
  },
}
