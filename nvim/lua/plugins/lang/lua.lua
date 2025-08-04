vim.lsp.enable({ "emmylua_ls" })
return {
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "emmylua_ls" }, automatic_installation = { enabled = true, exclude = { "lua_ls" } } },
  },
}
