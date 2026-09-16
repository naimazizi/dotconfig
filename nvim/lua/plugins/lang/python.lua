vim.pack.add({ Config.gh("linux-cultist/venv-selector.nvim") })

Config.on_filetype("python", function()
  require("venv-selector").setup({
    options = {
      notify_user_on_venv_activation = true,
    },
  })

  vim.keymap.set("n", "<leader>cv", "<cmd>:VenvSelect<cr>", { desc = "Select VirtualEnv" })
end)
