return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "jsonls" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    ft = "json",
    config = function()
      vim.lsp.enable({ "jsonls" })
    end,
  },
}
