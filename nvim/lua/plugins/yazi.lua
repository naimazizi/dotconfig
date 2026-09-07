if vim.g.vscode then
  return
end

vim.pack.add({ Config.gh("nvim-lua/plenary.nvim"), Config.gh("mikavilpas/yazi.nvim") })

Config.later(function()
  require("yazi").setup({
    open_for_directories = true,
    keymaps = {
      show_help = "<f1>",
    },
  })

  vim.keymap.set({ "n", "v" }, "<leader>fE", "<cmd>Yazi<cr>", { desc = "Open yazi at the current file" })
  vim.keymap.set("n", "<leader>fe", "<cmd>Yazi toggle<cr>", { desc = "Resume the last yazi session" })
end)
