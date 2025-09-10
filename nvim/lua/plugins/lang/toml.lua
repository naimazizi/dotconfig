vim.lsp.enable({ "tombi" })

return {
  {
    "stevearc/conform.nvim",
    cond = not vim.g.vscode,
    event = { "BufWritePre" },
    opts = function()
      conform = require("conform")
      conform.formatters_by_ft["toml"] = "tombi"
    end,
  },
}
