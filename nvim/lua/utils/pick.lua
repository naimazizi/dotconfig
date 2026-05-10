local M = {}

-- Layout configuration for snacks.picker
M.layout = {
  layout = {
    backdrop = false,
    row = 1,
    width = 0.6,
    min_width = 80,
    height = 0.6,
    border = "none",
    box = "vertical",
    { win = "input", height = 1, border = true, title = "{title} {live} {flags}", title_pos = "center" },
    { win = "list", border = "hpad" },
    { win = "preview", title = "{preview}", border = true },
  },
}

--- Check if any attached LSP client is known to have snacks.picker compatibility issues
local function has_incompatible_lsp()
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    if client.name:match("^otter") then
      return true
    end
  end
  return false
end

--- Try snacks.picker LSP, fall back to builtin on error or incompatible LSP
---@param snacks_fn function
---@param fallback function
---@param opts? table
local function lsp_with_fallback(snacks_fn, fallback, opts)
  if has_incompatible_lsp() then
    fallback()
    return
  end
  local options = opts or {}
  options.layout = options.layout or M.layout

  local ok = pcall(snacks_fn, options)
  if not ok then
    fallback()
  end
end

-- Set LSP keymaps on a buffer using snacks.picker
function M.lsp_keymaps(bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end

  map("n", "gd", function()
    lsp_with_fallback(Snacks.picker.lsp_definitions, vim.lsp.buf.definition)
  end, "Goto definition")
  map("n", "gr", function()
    lsp_with_fallback(Snacks.picker.lsp_references, function()
      vim.lsp.buf.references(nil, { includeDeclaration = false })
    end)
  end, "References")
  map("n", "gi", function()
    lsp_with_fallback(Snacks.picker.lsp_implementations, vim.lsp.buf.implementation)
  end, "Goto implementation")
  map("n", "gy", function()
    lsp_with_fallback(Snacks.picker.lsp_type_definitions, vim.lsp.buf.type_definition)
  end, "Goto type definition")

  map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
  map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")

  map("n", "<leader>ss", function()
    lsp_with_fallback(Snacks.picker.lsp_symbols, vim.lsp.buf.document_symbol)
  end, "Symbols (document)")
  map("n", "<leader>sS", function()
    lsp_with_fallback(Snacks.picker.lsp_workspace_symbols, vim.lsp.buf.workspace_symbol)
  end, "Symbols (workspace)")

  map("n", "<leader>ci", function()
    Snacks.picker.lsp_incoming_calls()
  end, "Incoming calls")
  map("n", "<leader>co", function()
    Snacks.picker.lsp_outgoing_calls()
  end, "Outgoing calls")

  map("n", "<leader>cc", vim.lsp.codelens.run, "CodeLens")
end

return M
