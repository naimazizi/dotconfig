local function lsp_keymaps(bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end

  local ok_pick, _ = pcall(require, "mini.pick")
  local ok_extras, extras = pcall(require, "mini.extra")

  local lsp_goto = function(scope)
    return function()
      if ok_pick and ok_extras and extras.pickers and extras.pickers.lsp then
        return extras.pickers.lsp({ scope = scope })
      end

      vim.notify(string.format("mini.pick/mini.extra not available for %s", scope), vim.log.levels.WARN)
    end
  end

  -- Remove default vim.lsp.buf goto mappings; use mini.pick instead
  map("n", "gd", lsp_goto("definition"), "Goto definition")
  map("n", "gr", lsp_goto("references"), "References")
  map("n", "gi", lsp_goto("implementation"), "Goto implementation")
  map("n", "gy", lsp_goto("type_definition"), "Goto type definition")

  map("n", "K", vim.lsp.buf.hover, "Hover")

  map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
  map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")

  -- Workspace symbols / document symbols
  map("n", "<leader>ss", lsp_goto("document_symbol"), "Symbols (document)")
  map("n", "<leader>sS", lsp_goto("workspace_symbol"), "Symbols (workspace)")

  -- CodeLens (conditionally mapped; not all servers support it)
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  local supports_codelens = vim.iter(clients):any(function(client)
    return client.supports_method("textDocument/codeLens")
  end)

  if supports_codelens then
    map("n", "<leader>cc", vim.lsp.codelens.run, "CodeLens")
    map("n", "<leader>cC", vim.lsp.codelens.refresh, "Refresh CodeLens")
  end

  map("n", "gK", vim.lsp.buf.signature_help, "Signature help")

  for _, key in ipairs({ "gra", "gri", "grn", "grr", "grt" }) do
    pcall(vim.keymap.del, "n", key, { buffer = bufnr })
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "saghen/blink.cmp",
    },
    opts = {
      servers = {},
    },
    config = function()
      local ok_blink, blink = pcall(require, "blink.cmp")
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      if ok_blink and type(blink.get_lsp_capabilities) == "function" then
        capabilities = blink.get_lsp_capabilities(capabilities)
      end

      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰅚 ",
            [vim.diagnostic.severity.INFO] = "󰅚 ",
            [vim.diagnostic.severity.HINT] = "󰅚 ",
          },
        },
        virtual_text = {
          source = "if_many",
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          lsp_keymaps(args.buf)
        end,
      })
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
  {
    "zeioth/garbage-day.nvim",
    dependencies = "neovim/nvim-lspconfig",
    event = "VeryLazy",
    opts = {},
  },
}
