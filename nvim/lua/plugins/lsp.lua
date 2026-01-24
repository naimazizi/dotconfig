-- Telescope LSP pickers for the given scope
---@param scope "declaration" | "definition" | "document_symbol" | "implementation" | "references" | "type_definition" | "workspace_symbol"
local function telescope_lsp(scope)
  return function()
    local ok, builtin = pcall(require, "telescope.builtin")
    if not ok then
      vim.notify("telescope.nvim not available", vim.log.levels.WARN)
      return
    end

    if scope == "references" then
      builtin.lsp_references()
      return
    end

    if scope == "definition" then
      builtin.lsp_definitions()
      return
    end

    if scope == "implementation" then
      builtin.lsp_implementations()
      return
    end

    if scope == "type_definition" then
      builtin.lsp_type_definitions()
      return
    end

    if scope == "document_symbol" then
      builtin.lsp_document_symbols()
      return
    end

    if scope == "workspace_symbol" then
      builtin.lsp_dynamic_workspace_symbols()
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

  -- Remove default vim.lsp.buf goto mappings; use telescope instead
  map("n", "gd", telescope_lsp("definition"), "Goto definition")
  map("n", "gr", telescope_lsp("references"), "References")
  map("n", "gi", telescope_lsp("implementation"), "Goto implementation")
  map("n", "gy", telescope_lsp("type_definition"), "Goto type definition")

  map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
  map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")

  -- Workspace symbols / document symbols
  map("n", "<leader>ss", telescope_lsp("document_symbol"), "Symbols (document)")
  map("n", "<leader>sS", telescope_lsp("workspace_symbol"), "Symbols (workspace)")

  -- LSP call
  map("n", "<leader>ci", "<cmd>Telescope hierarchy incoming_calls<cr>", "Incoming Calls")
  map("n", "<leader>co", "<cmd>Telescope hierarchy outgoing_calls<cr>", "Outgoing Calls")

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
  {
    "SmiteshP/nvim-navic",
    vscode = false,
    event = "LspAttach",
    dependencies = "neovim/nvim-lspconfig",
    config = function(_, opts)
      require("nvim-navic").setup(opts)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.server_capabilities.documentSymbolProvider then
            require("nvim-navic").attach(client, args.buf)
          end
        end,
      })

      vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
    end,
  },
}
