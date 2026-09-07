if vim.g.vscode then
  return
end

local oxfmt_supported_ft = {
  "astro",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "svelte",
  "toml",
  "typescript",
  "typescriptreact",
  "vue",
  "yaml",
  "yml",
}

vim.pack.add({ Config.gh("stevearc/conform.nvim") })

Config.later(function()
  local formatters_by_ft = {}
  local formatters = {}

  -- Markdown formatters
  for _, ft in ipairs(vim.g.md_ft or {}) do
    formatters_by_ft[ft] = formatters_by_ft[ft] or {}
    table.insert(formatters_by_ft[ft], "panache")
  end

  -- Typst formatters
  formatters_by_ft["typst"] = { "typstyle" }

  -- Python formatters
  for _, ft in ipairs({ "python" }) do
    formatters_by_ft[ft] = formatters_by_ft[ft] or {}
    table.insert(formatters_by_ft[ft], "ruff_format")
  end

  -- SQL formatters
  for _, ft in ipairs(vim.g.sql_ft or {}) do
    formatters_by_ft[ft] = { "sqlfmt" }
    -- formatters_by_ft[ft] = { "dawet_lint" } -- slow
  end

  -- Lua formatter
  formatters_by_ft["lua"] = { "stylua" }

  -- shell formatter
  for _, ft in ipairs(vim.g.sh_ft or {}) do
    formatters_by_ft[ft] = { "shfmt" }
  end

  -- kdl formatter
  formatters_by_ft["kdl"] = { "kdlfmt" }

  -- oxfmt for various web-related filetypes
  for _, ft in ipairs(oxfmt_supported_ft) do
    formatters_by_ft[ft] = formatters_by_ft[ft] or {}
    table.insert(formatters_by_ft[ft], "oxfmt")
  end

  -- Injected formatter for code blocks in markdown-like file
  for _, ft in ipairs(vim.g.md_injected_ft or {}) do
    formatters_by_ft[ft] = formatters_by_ft[ft] or {}
    table.insert(formatters_by_ft[ft], "injected")
  end
  -- Customize the "injected" formatter
  formatters.injected = {
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

  require("conform").setup({
    formatters_by_ft = formatters_by_ft,
    formatters = formatters,
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_format = "fallback" }
    end,
  })

  vim.keymap.set({ "n", "x" }, "<leader>cf", function()
    require("conform").format({ async = true, lsp_format = "fallback" })
  end, { desc = "Format" })
end)
