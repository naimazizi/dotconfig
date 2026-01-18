vim.lsp.config("marksman", {})
vim.lsp.enable({ "marksman" })

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    vscode = false,
    event = "VeryLazy",
    ft = vim.g.md_ft,
    opts = {
      render_modes = true, -- enable all modes
      file_types = vim.g.md_ft,
      code = {
        enable = true, -- enable code block rendering
        style = "full",
        width = "full",
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "marksman" })
    end,
  },
}
