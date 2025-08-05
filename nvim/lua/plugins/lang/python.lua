local lsp = "pyrefly"
vim.lsp.enable({ lsp, "ruff" })

return {
  recommended = function()
    return LazyVim.extras.wants({
      ft = "python",
      root = {
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        "pyrightconfig.json",
      },
    })
  end,
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "ninja", "rst" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruff = {
          cmd_env = { RUFF_TRACE = "messages" },
          init_options = {
            settings = {
              logLevel = "error",
            },
          },
          keys = {
            {
              "<leader>co",
              LazyVim.lsp.action["source.organizeImports"],
              desc = "Organize Imports",
            },
          },
        },
        pyright = {
          analysis = {
            typeCheckingMode = "strict",
            single_file_support = true,
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "openFilesOnly",
              useLibraryCodeForTypes = true,
            },
          },
          disableOrganizeImports = true,
        },
        basedpyright = {
          analysis = {
            typeCheckingMode = "standard",
            single_file_support = true,
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "openFilesOnly",
              useLibraryCodeForTypes = true,
            },
          },
          disableOrganizeImports = true,
        },
      },
      setup = {
        ["ruff"] = function()
          LazyVim.lsp.on_attach(function(client, _)
            -- Disable hover in favor of other lsp
            client.server_capabilities.hoverProvider = false
          end, "ruff")
        end,
      },
    },
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          -- Here you can specify the settings for the adapter, i.e.
          -- runner = "pytest",
          -- python = ".venv/bin/python",
        },
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      "mfussenegger/nvim-dap-python",
      -- stylua: ignore
      keys = {
        { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
        { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
      },
      config = function()
        require("dap-python").setup("debugpy-adapter")
      end,
    },
  },
  {
    "linux-cultist/venv-selector.nvim",
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
    optional = true,
    opts = {
      handlers = {
        python = function() end,
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    config = function(_, _)
      require("mason-lspconfig").setup({
        ensure_installed = { "ruff" },
        automatic_installation = { enable = true, exclude = { "pyright", "basedpyright" } },
      })
    end,
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
}
