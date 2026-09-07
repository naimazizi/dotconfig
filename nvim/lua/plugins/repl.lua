if vim.g.vscode then
  return
end

vim.g.slime_no_mappings = 1
vim.pack.add({ Config.gh("jpalardy/vim-slime") })

Config.on_filetype("python", function()
  local map = vim.keymap.set
  map("n", "<localleader>rC", "<cmd>SlimeConfig<cr>", { desc = "Slime Config" })
  map("n", "<localleader>rr", "<Plug>SlimeSendCell<BAR>/^# %%<CR>", { desc = "Slime Send Cell" })
  map("v", "<localleader>rr", ":<C-u>'<,'>SlimeSend<CR>", { desc = "Slime Send Selection" })
  map("v", "<localleader>r<cr>", "<Plug>SlimeLineSend<CR>", { desc = "Slime Send Selection" })
end)
