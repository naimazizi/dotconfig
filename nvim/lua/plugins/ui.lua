if vim.g.vscode then
  return
end

vim.pack.add({
  Config.gh("MunifTanjim/nui.nvim"),
  Config.gh("petertriho/nvim-scrollbar"),
  Config.gh("hedyhli/outline.nvim"),
  Config.gh("shortcuts/no-neck-pain.nvim"),
  Config.gh("TheNoeTrevino/haunt.nvim"),
})

Config.on_event("BufRead", function()
  require("scrollbar").setup({})
end)

Config.later(function()
  require("outline").setup({
    outline_window = { position = "left", auto_jump = true, wrap = false },
    keymaps = {
      down_and_jump = {},
      up_and_jump = {},
    },
  })
  vim.keymap.set("n", "<leader>cs", "<cmd>Outline<cr>", { desc = "Toggle Outline" })
end)

Config.later(function()
  vim.keymap.set("n", "<leader>uz", "<cmd>NoNeckPain<cr>", { desc = "Toggle zen-mode" })
end)

Config.on_event("BufReadPost", function()
  require("haunt").setup({
    sign = "󱙝",
    sign_hl = "DiagnosticInfo",
    virt_text_hl = "HauntAnnotation",
    annotation_prefix = " 󰆉 ",
    line_hl = nil,
    virt_text_pos = "eol",
    data_dir = nil,
    picker_keys = {
      delete = { key = "d", mode = { "n" } },
      edit_annotation = { key = "a", mode = { "n" } },
    },
  })

  local map = vim.keymap.set
  local prefix = "<leader>h"

  -- annotations
  map("n", prefix .. "a", function()
    require("haunt.api").annotate()
  end, { desc = "Annotate" })

  map("n", prefix .. "t", function()
    require("haunt.api").toggle_annotation()
  end, { desc = "Toggle annotation" })

  map("n", prefix .. "T", function()
    require("haunt.api").toggle_all_lines()
  end, { desc = "Toggle all annotations" })

  map("n", prefix .. "d", function()
    require("haunt.api").delete()
  end, { desc = "Delete bookmark" })

  map("n", prefix .. "C", function()
    require("haunt.api").clear_all()
  end, { desc = "Delete all bookmarks" })

  -- quickfix
  map("n", prefix .. "q", function()
    require("haunt.api").to_quickfix()
  end, { desc = "Send Hauntings to QF Lix (buffer)" })

  map("n", prefix .. "Q", function()
    require("haunt.api").to_quickfix({ current_buffer = true })
  end, { desc = "Send Hauntings to QF Lix (all)" })

  -- yank
  map("n", prefix .. "y", function()
    require("haunt.api").yank_locations({ current_buffer = true })
  end, { desc = "Send Hauntings to Clipboard (buffer)" })

  map("n", prefix .. "Y", function()
    require("haunt.api").yank_locations()
  end, { desc = "Send Hauntings to Clipboard (all)" })

  -- move
  map("n", prefix .. "p", function()
    require("haunt.api").prev()
  end, { desc = "Previous bookmark" })

  map("n", prefix .. "n", function()
    require("haunt.api").next()
  end, { desc = "Next bookmark" })

  -- picker
  map("n", prefix .. "h", function()
    require("haunt.picker").show()
  end, { desc = "Show Picker" })
end)
