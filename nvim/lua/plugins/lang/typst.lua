if vim.g.vscode then
  return
end

vim.pack.add({ Config.gh("chomosuke/typst-preview.nvim") })

Config.on_filetype("typst", function()
  require("typst-preview").setup({
    dependencies_bin = {
      tinymist = "tinymist",
    },
  })

  vim.keymap.set("n", "<leader>cp", "<cmd>TypstPreviewToggle<cr>", { desc = "Toggle Typst Preview" })
end)
