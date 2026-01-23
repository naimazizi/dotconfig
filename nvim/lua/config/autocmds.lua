local group = vim.api.nvim_create_augroup("nvim_minimax", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- LSP document highlight on idle cursor (skip mini.starter)
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  group = group,
  callback = function(args)
    local buf = args.buf
    if not vim.api.nvim_buf_is_valid(buf) then
      return
    end
    if vim.bo[buf].filetype == "ministarter" then
      return
    end

    local clients = vim.lsp.get_clients({ bufnr = buf })
    for _, client in ipairs(clients) do
      if client.supports_method("textDocument/documentHighlight") then
        pcall(vim.lsp.buf.document_highlight)
        return
      end
    end
  end,
  desc = "LSP: document highlight under cursor",
})

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
  group = group,
  callback = function(args)
    local buf = args.buf
    if not vim.api.nvim_buf_is_valid(buf) then
      return
    end
    if vim.bo[buf].filetype == "ministarter" then
      return
    end

    pcall(vim.lsp.buf.clear_references)
  end,
  desc = "LSP: clear document highlights",
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_attach_disable_hover", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end
    if client.server_capabilities == nil then
      return
    end
    if client.name == "ruff" then
      client.server_capabilities.hoverProvider = false
    end
  end,
  desc = "LSP: Disable hover capability from specific LSP",
})
