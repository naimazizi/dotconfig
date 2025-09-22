vim.lsp.enable({ "emmylua_ls" })

return {
  {
    "stevearc/conform.nvim",
    vscode = false,
    event = { "BufWritePre" },
    opts = function()
      conform = require("conform")
      conform.formatters_by_ft["lua"] = "stylelua"
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "emmylua_ls" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        emmylua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
        lua_ls = { mason = false },
      },
    },
  },
}
