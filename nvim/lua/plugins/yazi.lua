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

  vim.g.loaded_nvim_dir_plugin = false

  vim.keymap.set({ "n", "v" }, "<leader>fE", "<cmd>Yazi<cr>", { desc = "Open yazi at the current file" })
  vim.keymap.set("n", "<leader>fe", "<cmd>Yazi toggle<cr>", { desc = "Resume the last yazi session" })
  vim.keymap.set("n", "-", "<cmd>Yazi toggle<cr>", { desc = "Resume the last yazi session" })
end)
