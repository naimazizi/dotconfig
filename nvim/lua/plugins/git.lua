if vim.g.vscode then
  return
end

vim.pack.add({
  Config.gh("nvim-lua/plenary.nvim"),
  Config.gh("pwntester/octo.nvim"),
  Config.gh("tanvirtin/vgit.nvim"),
})

Config.on_event("VimEnter", function()
  require("vgit").setup()

  local map = vim.keymap.set
  map("n", "<leader>gv", "<cmd>VGit buffer_diff_preview<cr>", { desc = "Preview Git changes" })
  map("n", "<leader>gb", "<cmd>VGit buffer_blame_preview<cr>", { desc = "Show line blame" })
  map("n", "<leader>gh", "<cmd>VGit buffer_history_preview<cr>", { desc = "Show file history" })
  map("n", "<leader>gs", "<cmd>VGit buffer_hunk_stage<cr>", { desc = "Stage Git hunk" })
  map("n", "<leader>gS", "<cmd>VGit buffer_unstage<cr>", { desc = "Unstage Git buffer" })
  map("n", "<leader>gr", "<cmd>VGit buffer_hunk_reset<cr>", { desc = "Reset Git hunk" })
  map("n", "<leader>gR", "<cmd>VGit buffer_reset<cr>", { desc = "Reset Git buffer" })
  map("n", "<leader>gp", "<cmd>VGit buffer_hunk_preview<cr>", { desc = "Preview Git hunk" })
  map("n", "<leader>gd", "<cmd>VGit project_diff_preview<cr>", { desc = "Preview project Git changes" })
  map("n", "<leader>gx", "<cmd>VGit toggle_diff_preference<cr>", { desc = "Toggle Git diff layout" })
  map("n", "[h", "<cmd>VGit hunk_up<cr>", { desc = "Previous Git hunk" })
  map("n", "]h", "<cmd>VGit hunk_down<cr>", { desc = "Next Git hunk" })
end)

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
  map("n", "<leader>gP", "<cmd>Octo pr list<cr>", { desc = "List GitHub PRs" })
end)
