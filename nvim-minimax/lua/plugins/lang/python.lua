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
        -- ruff = {
        --   keys = {
        --     {
        --       "<leader>co",
        --       LazyVim.lsp.action["source.organizeImports"],
        --       desc = "Organize Imports",
        --     },
        --   },
        -- },
      },
      setup = {
        ["ruff"] = function()
          -- Snacks.util.lsp.on({ name = "ruff" }, function(_, client)
          --   ---@diagnostic disable-next-line: need-check-nil
          --   -- Disable hover in favor of Pyright
          --   client.server_capabilities.hoverProvider = false
          -- end)
        end,
      },
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
}
