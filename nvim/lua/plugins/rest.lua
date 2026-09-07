if vim.g.vscode then
  return
end

vim.pack.add({
  Config.gh("jellydn/hurl.nvim"),
  Config.gh("MunifTanjim/nui.nvim"),
  Config.gh("nvim-lua/plenary.nvim"),
  Config.gh("nvim-treesitter/nvim-treesitter"),
})

Config.on_filetype("hurl", function()
  require("hurl").setup({
    -- Show debugging info
    debug = false,
    -- Show notification on run
    show_notification = false,
    -- Show response in popup or split
    mode = "split",
    -- Default formatter
    formatters = {
      json = { "jq" }, -- Make sure you have install jq in your system, e.g: brew install jq
    },
    -- Default mappings for the response popup or split views
    mappings = {
      close = "q", -- Close the response popup or split view
      next_panel = "<C-n>", -- Move to the next response popup window
      prev_panel = "<C-p>", -- Move to the previous response popup window
    },
  })

  local map = vim.keymap.set
  -- Run API request
  map("n", "<localleader>cC", "<cmd>HurlRunner<CR>", { desc = "Run All requests" })
  map("n", "<localleader>cc", "<cmd>HurlRunnerAt<CR>", { desc = "Run Api request" })
  map("n", "<localleader>ce", "<cmd>HurlRunnerToEntry<CR>", { desc = "Run Api request to entry" })
  map("n", "<localleader>cE", "<cmd>HurlRunnerToEnd<CR>", { desc = "Run Api request from current entry to end" })
  map("n", "<localleader>ct", "<cmd>HurlToggleMode<CR>", { desc = "Hurl Toggle Mode" })
  map("n", "<localleader>cv", "<cmd>HurlVerbose<CR>", { desc = "Run Api in verbose mode" })
  map("n", "<localleader>cV", "<cmd>HurlVeryVerbose<CR>", { desc = "Run Api in very verbose mode" })
  -- Run Hurl request in visual mode
  map("v", "<localleader>cc", ":HurlRunner<CR>", { desc = "Hurl Runner" })
end)
