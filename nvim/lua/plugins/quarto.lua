if vim.g.vscode then
  return
end

vim.pack.add({
  Config.gh("quarto-dev/quarto-nvim"),
  Config.gh("jmbuhr/otter.nvim"),
})

Config.later(function()
  require("quarto").setup({
    debug = false,
    closePreviewOnExit = true,
    lspFeatures = {
      enabled = true,
      chunks = "curly",
      languages = { "r", "python", "julia" },
      diagnostics = {
        enabled = true,
        triggers = { "BufWritePost" },
      },
      completion = {
        enabled = true,
      },
    },
    codeRunner = {
      enabled = true,
      default_method = "slime", -- "molten", "slime", "iron" or <function>
    },
  })
  local runner = require("quarto.runner")
  table.insert(require("mini.clue").config.clues, { mode = "n", keys = "<localleader>s", desc = "+Quarto" })
  vim.keymap.set("n", "<localleader>ss", runner.run_cell, { desc = "run cell", silent = true })
  vim.keymap.set("n", "<localleader>sa", runner.run_above, { desc = "run cell and above", silent = true })
  vim.keymap.set("n", "<localleader>sA", runner.run_all, { desc = "run all cells", silent = true })
  vim.keymap.set("n", "<localleader>se", runner.run_line, { desc = "run line", silent = true })
  vim.keymap.set("v", "<localleader>ss", runner.run_range, { desc = "run visual range", silent = true })
  vim.keymap.set("n", "<localleader>sf", function()
    runner.run_all(true)
  end, { desc = "run all cells of all languages", silent = true })
end)
