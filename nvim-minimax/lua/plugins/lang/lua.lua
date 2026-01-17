vim.lsp.config("emmylua_ls", {
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
      -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      -- diagnostics = { disable = { 'missing-fields' } },
    },
  },
})

vim.lsp.enable({ "emmylua_ls" })

return {
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "emmylua_ls" } },
  },
}
