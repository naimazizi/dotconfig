if vim.g.vscode then
  return
end

vim.pack.add({ Config.gh("dlyongemallo/diffview-plus.nvim") })

Config.later(function()
  require("diffview").setup({})
end)
