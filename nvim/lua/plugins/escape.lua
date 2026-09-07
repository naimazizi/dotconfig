if vim.g.vscode then
  return
end

vim.pack.add({ Config.gh("max397574/better-escape.nvim") })

Config.on_event("InsertEnter", function()
  require("better_escape").setup({
    timeout = 100, -- time in milliseconds to wait for a second key press
  })
end)
