vim.lsp.enable({ "emmylua_ls" })

return {
  {
    "stevearc/conform.nvim",
    cond = not vim.g.vscode,
    event = { "BufWritePre" },
    opts = function()
      conform = require("conform")
      conform.formatters_by_ft["lua"] = "stylelua"
    end,
  },
}
