if vim.g.vscode then
  return
end

vim.pack.add({
  Config.gh("nvim-lua/plenary.nvim"),
  Config.gh("pwntester/octo.nvim"),
})

Config.later(function()
  require("octo").setup({
    picker = "fzf-lua",
    enable_builtin = true,
    file_panel = {
      icons = function(name, _ext)
        return require("mini.icons").get("file", name)
      end,
    },
  })

  local map = vim.keymap.set
  map("n", "<leader>go", "<cmd>Octo<cr>", { desc = "Octo actions" })
  map("n", "<leader>gi", "<cmd>Octo issue list<cr>", { desc = "List GitHub Issues" })
  map("n", "<leader>gp", "<cmd>Octo pr list<cr>", { desc = "List GitHub PRs" })
end)
