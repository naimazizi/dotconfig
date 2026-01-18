return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "emmylua_ls" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    ft = "lua",
    config = function()
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
    end,
  },
}
