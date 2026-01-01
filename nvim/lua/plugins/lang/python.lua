local lsp = "pyrefly"

vim.lsp.enable({ lsp, "ruff" })

return {
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { lsp, "ruff" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- ty = {
        --   diagnosticMode = "workspace",
        --   completions = {
        --     autoImport = true,
        --   },
        -- },
        pyrefly = {},
        ruff = {
          cmd = { "ruff", "server" },
          keys = {
            {
              "<leader>co",
              LazyVim.lsp.action["source.organizeImports"],
              desc = "Organize Imports",
            },
          },
        },
      },
      setup = {
        ["ruff"] = function()
          Snacks.util.lsp.on({ name = "ruff" }, function(_, client)
            ---@diagnostic disable-next-line: need-check-nil
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
          end)
        end,
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "ninja", "rst" } },
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
    cmd = "VenvSelect",
    opts = {
      options = {
        notify_user_on_venv_activation = true,
        picker = "fzf-lua",
        statusline_func = {
          lualine = function()
            local venv_path = require("venv-selector").venv()
            if not venv_path or venv_path == "" then
              return ""
            end

            local venv_name = vim.fn.fnamemodify(venv_path, ":t")
            if not venv_name then
              return ""
            end

            local output = "󱔎 " .. venv_name .. " " -- Changes only the icon but you can change colors or use powerline symbols here.
            return output
          end,
        },
      },
    },
    --  Call config for Python files and load the cached venv automatically
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
}
