local lsp = "pyrefly"

vim.lsp.config(lsp, {})
vim.lsp.config("ruff", {
  on_attach = function(client, bufnr)
    if client.name ~= "ruff" then
      return
    end

    vim.keymap.set("n", "<leader>co", function()
      vim.lsp.buf.code_action({
        context = {
          only = { "source.organizeImports" },
          diagnostics = {},
        },
        apply = true,
      })
    end, { buffer = bufnr, silent = true, desc = "Organize Imports" })
  end,
})

vim.lsp.enable({ lsp, "ruff" })

return {
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { lsp, "ruff" } },
  },
  {
    "linux-cultist/venv-selector.nvim",
    cmd = "VenvSelect",
    opts = {
      options = {
        notify_user_on_venv_activation = true,
        picker = "mini-pick",
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

            local output = "󱔎 " .. venv_name .. " "
            return output
          end,
        },
      },
    },
    ft = "python",
    keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" } },
  },
}
