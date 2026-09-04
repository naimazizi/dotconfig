local M = {}

-- Set LSP keymaps on a buffer using fzf-lua
function M.lsp_keymaps(bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end

  local fzf = require("fzf-lua")

  map("n", "gd", fzf.lsp_definitions, "Goto definition")
  map("n", "gD", fzf.lsp_declarations, "Goto Declaration")
  map("n", "gr", fzf.lsp_references, "References")
  map("n", "gi", fzf.lsp_implementations, "Goto implementation")
  map("n", "gy", fzf.lsp_typedefs, "Goto type definition")

  map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
  map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")

  map("n", "<leader>ss", fzf.lsp_document_symbols, "Symbols (document)")
  map("n", "<leader>sS", fzf.lsp_workspace_symbols, "Symbols (workspace)")

  map("n", "<leader>ci", fzf.lsp_incoming_calls, "Incoming calls")
  map("n", "<leader>co", fzf.lsp_outgoing_calls, "Outgoing calls")

  map("n", "<leader>cc", vim.lsp.codelens.run, "CodeLens")
end

return M
