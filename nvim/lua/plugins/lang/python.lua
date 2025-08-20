vim.lsp.config("ruff", {
  init_options = {
    settings = {
      logLevel = "error",
    },
  },
})

vim.lsp.enable({ "pyrefly", "ruff" })

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end
    if client.name == "ruff" then
      -- Disable hover in favor of other LSP
      client.server_capabilities.hoverProvider = false
    end
  end,
  desc = "LSP: Disable hover capability from Ruff",
})

return {
  {
    "nvim-neotest/neotest",
    cond = not vim.g.vscode,
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          -- Here you can specify the settings for the adapter, i.e.
          runner = "pytest",
          -- python = ".venv/bin/python",
        },
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    cond = not vim.g.vscode,
    optional = true,
    dependencies = {
      "mfussenegger/nvim-dap-python",
            -- stylua: ignore
            keys = {
                { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
                { "<leader>dPc", function() require('dap-python').test_class() end,  desc = "Debug Class",  ft = "python" },
            },
      config = function()
        require("dap-python").setup("debugpy-adapter")
      end,
    },
  },
  {
    "linux-cultist/venv-selector.nvim",
    cond = not vim.g.vscode,
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
  -- Don't mess up DAP adapters provided by nvim-dap-python
  {
    "jay-babu/mason-nvim-dap.nvim",
    cond = not vim.g.vscode,
    optional = true,
    opts = {
      handlers = {
        python = function() end,
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    cond = not vim.g.vscode,
    event = { "BufWritePre" },
    opts = function()
      conform = require("conform")
      conform.formatters_by_ft["python"] = {
        "ruff_fix",
        "ruff_format",
        "ruff_organize_imports",
      }
    end,
  },
}
