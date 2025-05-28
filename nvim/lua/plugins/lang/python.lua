return {
  {
    "nvim-lspconfig",
    opts = function(_, opts)
      -- opts.servers.pyright = {
      --   settings = {
      --     pyright = {
      --       analysis = {
      --         typeCheckingMode = "strict",
      --         single_file_support = true,
      --         analysis = {
      --           autoSearchPaths = true,
      --           diagnosticMode = "openFilesOnly",
      --           useLibraryCodeForTypes = true,
      --         },
      --       },
      --       disableOrganizeImports = true,
      --     },
      --   },
      -- }
      -- opts.servers.basedpyright = {
      --   settings = {
      --     basedpyright = {
      --       analysis = {
      --         typeCheckingMode = "standard",
      --         single_file_support = true,
      --         analysis = {
      --           autoSearchPaths = true,
      --           diagnosticMode = "openFilesOnly",
      --           useLibraryCodeForTypes = true,
      --         },
      --       },
      --       disableOrganizeImports = true,
      --     },
      --   },
      -- }
      vim.lsp.config("pyrefly", {})
      vim.lsp.enable({ "pyrefly" })

      -- vim.lsp.config("ty", {})
      -- vim.lsp.enable({ "ty" })
    end,
  },
  {
    "linux-cultist/venv-selector.nvim",
    enabled = true,
    branch = "regexp", -- Use this branch for the new version
    cmd = "VenvSelect",
    opts = {
      settings = {
        options = {
          notify_user_on_venv_activation = true,
        },
      },
    },
    --  Call config for python files and load the cached venv automatically
    ft = "python",
    keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" } },
  },
}
