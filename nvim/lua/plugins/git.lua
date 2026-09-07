if vim.g.vscode then
  return
end

vim.pack.add({ Config.gh("lewis6991/gitsigns.nvim") })

Config.later(function()
  require("gitsigns").setup({
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text_pos = "right_align",
      delay = 500,
    },
  })

  vim.keymap.set({ "o", "x" }, "ih", "<cmd>Gitsigns select_hunk<cr>")

  local map = vim.keymap.set
  map("n", "]h", function()
    require("gitsigns").next_hunk()
  end, { desc = "Next hunk" })
  map("n", "[h", function()
    require("gitsigns").prev_hunk()
  end, { desc = "Prev hunk" })
  map({ "n", "v" }, "<leader>gs", function()
    require("gitsigns").stage_hunk()
  end, { desc = "Stage hunk" })
  map({ "n", "v" }, "<leader>gr", function()
    require("gitsigns").reset_hunk()
  end, { desc = "Reset hunk" })
  map("n", "<leader>gS", function()
    require("gitsigns").stage_buffer()
  end, { desc = "Stage buffer" })
  map("n", "<leader>gR", function()
    require("gitsigns").reset_buffer()
  end, { desc = "Reset buffer" })
  map("n", "<leader>gv", function()
    require("gitsigns").preview_hunk()
  end, { desc = "Preview hunk" })
  map("n", "<leader>gb", function()
    require("gitsigns").blame()
  end, { desc = "Git Blame" })
end)
