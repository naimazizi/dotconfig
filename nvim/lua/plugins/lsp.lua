-- fzf-lua LSP pickers for the given scope
---@param scope "declaration" | "definition" | "document_symbol" | "implementation" | "references" | "type_definition" | "workspace_symbol" | "incoming_calls" | "outgoing_calls" | "code_action"
local function fzf_lua_lsp(scope)
  return function()
    local ok, fzf = pcall(require, "fzf-lua")
    if not ok then
      vim.notify("fzf-lua not available", vim.log.levels.WARN)
      return
    end

    local lsp_mappings = {
      references = "lsp_references",
      definition = "lsp_definitions",
      implementation = "lsp_implementations",
      type_definition = "lsp_typedefs",
      document_symbol = "lsp_document_symbols",
      workspace_symbol = "lsp_live_workspace_symbols",
      incoming_calls = "lsp_incoming_calls",
      outgoing_calls = "lsp_outgoing_calls",
      code_action = "lsp_code_actions",
    }

    local fn_name = lsp_mappings[scope]
    if fn_name and fzf[fn_name] then
      fzf[fn_name]()
      return
    end

    -- Fallback for less common scopes
    pcall(vim.lsp.buf[scope])
  end
end

local function lsp_keymaps(bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end

  -- Remove default vim.lsp.buf goto mappings; use fzf-lua instead
  map("n", "gd", fzf_lua_lsp("definition"), "Goto definition")
  map("n", "gr", fzf_lua_lsp("references"), "References")
  map("n", "gi", fzf_lua_lsp("implementation"), "Goto implementation")
  map("n", "gy", fzf_lua_lsp("type_definition"), "Goto type definition")

  map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
  map({ "n", "x" }, "<leader>ca", fzf_lua_lsp("code_action"), "Code action")

  -- Workspace symbols / document symbols
  map("n", "<leader>ss", fzf_lua_lsp("document_symbol"), "Symbols (document)")
  map("n", "<leader>sS", fzf_lua_lsp("workspace_symbol"), "Symbols (workspace)")

  -- LSP calls
  map("n", "<leader>ci", fzf_lua_lsp("incoming_calls"), "Symbols (document)")
  map("n", "<leader>co", fzf_lua_lsp("outgoing_calls"), "Symbols (workspace)")

  -- CodeLens (conditionally mapped; not all servers support it)
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  local supports_codelens = vim.iter(clients):any(function(client)
    return client.supports_method("textDocument/codeLens")
  end)

  if supports_codelens then
    map("n", "<leader>cc", vim.lsp.codelens.run, "CodeLens")
    map("n", "<leader>cC", vim.lsp.codelens.refresh, "Refresh CodeLens")
  end

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
    vscode = false,
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
    vscode = false,
    opts = {},
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
  {
    "zeioth/garbage-day.nvim",
    vscode = false,
    dependencies = "neovim/nvim-lspconfig",
    event = "VeryLazy",
    opts = {},
  },
}
