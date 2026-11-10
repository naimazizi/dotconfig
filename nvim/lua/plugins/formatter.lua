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

  formatters.panache = {
    env = { PANACHE_CONFIG = vim.fn.expand("~/.config/panache/config.toml") },
  }

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

  -- Hurl formatter
  formatters_by_ft["hurl"] = { "hurlfmt" }

  -- shell formatter
  for _, ft in ipairs(vim.g.sh_ft or {}) do
    formatters_by_ft[ft] = { "shuck" }
  end
  formatters.shuck = {
    command = "shuck",
    args = { "format", "--stdin-filename", "$FILENAME", "-" },
    stdin = true,
  }

  -- kdl formatter
  formatters_by_ft["kdl"] = { "kdlfmt" }

  -- terraform formatter
  formatters_by_ft["terraform"] = { "terraform_fmt" }

  -- oxfmt for various web-related filetypes
  for _, ft in ipairs(oxfmt_supported_ft) do
    formatters_by_ft[ft] = formatters_by_ft[ft] or {}
    table.insert(formatters_by_ft[ft], "oxfmt")
  end

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
