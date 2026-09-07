vim.pack.add({ Config.gh("stevearc/overseer.nvim") })

Config.later(function()
  require("overseer").setup({
    dap = false,
    task_list = {
      bindings = {
        ["<C-h>"] = false,
        ["<C-j>"] = false,
        ["<C-k>"] = false,
        ["<C-l>"] = false,
      },
      keymaps = {
        ["o"] = { "keymap.open", opts = { dir = "float" }, desc = "Open task" },
      },
    },
  })

  local map = vim.keymap.set
  map("n", "<leader>ow", "<cmd>OverseerToggle<cr>", { desc = "Task list" })
  map("n", "<leader>oo", "<cmd>OverseerRun<cr>", { desc = "Run task" })
  map("n", "<leader>oq", "<cmd>OverseerQuickAction<cr>", { desc = "Action recent task" })
  map("n", "<leader>ot", "<cmd>OverseerTaskAction<cr>", { desc = "Task action" })
end)
