return {
  {
    "stevearc/conform.nvim",
    vscode = false,
    keys = {
      {
        "<leader>uf",
        function()
          vim.g.autoformat = not vim.g.autoformat
          vim.notify("Autoformat " .. (vim.g.autoformat and "enabled" or "disabled"))
        end,
        desc = "Toggle autoformat",
      },
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        desc = "Format",
      },
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = "x",
        desc = "Format selection",
      },
    },
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters = opts.formatters or {}

      -- Markdown formatters
      for _, ft in ipairs(vim.g.md_ft or {}) do
        opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
        table.insert(opts.formatters_by_ft[ft], "rumdl")
      end

      -- Typst formatters
      -- Conform expects only formatter names in this list.
      opts.formatters_by_ft["typst"] = { "typstyle" }

      -- Python formatters
      for _, ft in ipairs({ "python" }) do
        opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
        table.insert(opts.formatters_by_ft[ft], "ruff_format")
      end

      -- SQL formatters
      for _, ft in ipairs(vim.g.sql_ft or {}) do
        opts.formatters_by_ft[ft] = { "sqlfmt" }
        -- opts.formatters_by_ft[ft] = { "dawet_lint" } -- slow
      end

      -- Lua formatter
      opts.formatters_by_ft["lua"] = { "stylua" }

      -- shell formatter
      for _, ft in ipairs(vim.g.sh_ft or {}) do
        opts.formatters_by_ft[ft] = { "shfmt" }
      end

      -- json formatter
      opts.formatters_by_ft["json"] = { "jq" }

      -- kdl formatter
      opts.formatters_by_ft["kdl"] = { "kdlfmt" }

      -- Injected formatter for code blocks in markdown-like file
      for _, ft in ipairs(vim.g.md_injected_ft or {}) do
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

      vim.g.autoformat = vim.g.autoformat ~= false

      opts.format_on_save = function(bufnr)
        if vim.g.autoformat == false then
          return
        end
        return {
          timeout_ms = 500,
          lsp_format = "fallback",
        }
      end

      return opts
    end,
  },
}
