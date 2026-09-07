if vim.g.vscode then
  return
end

vim.pack.add({
  Config.gh("folke/edgy.nvim"),
  Config.gh("MunifTanjim/nui.nvim"),
  Config.gh("petertriho/nvim-scrollbar"),
  Config.gh("hedyhli/outline.nvim"),
  Config.gh("shortcuts/no-neck-pain.nvim"),
  Config.gh("TheNoeTrevino/haunt.nvim"),
})

Config.later(function()
  require("edgy").setup({
    animate = { enabled = false },
    options = {
      left = { size = 0.20 },
      bottom = { size = 0.15 },
      right = { size = 0.30 },
    },
    keys = {
      -- increase width
      ["<c-Right>"] = function(win)
        win:resize("width", 2)
      end,
      -- decrease width
      ["<c-Left>"] = function(win)
        win:resize("width", -2)
      end,
      -- increase height
      ["<c-Up>"] = function(win)
        win:resize("height", 2)
      end,
      -- decrease height
      ["<c-Down>"] = function(win)
        win:resize("height", -2)
      end,
    },
    bottom = {
      { title = "Neotest Output", ft = "neotest-output-panel" },
      { title = "Overseer Output", ft = "OverseerOutput" },
      { title = "DAP", ft = "dap-view" },
      { title = "DAP", ft = "dap-repl" },
      { title = "DAP Term", ft = "dap-view-term" },
      {
        title = "Quickfix",
        ft = "qf",
      },
    },
    left = {
      {
        title = "Explorer",
        ft = "neo-tree",
        size = { height = 0.4 },
        pinned = false,
        open = function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
        end,
        filter = function(buf)
          return vim.b[buf].neo_tree_source == "filesystem"
        end,
      },
      {
        title = "Outline",
        ft = "Outline",
        pinned = false,
        open = "Outline",
        size = { height = 0.50 },
      },
      {
        title = "Overseer",
        ft = "OverseerList",
        open = function()
          require("overseer").open()
        end,
        size = { height = 0.4 },
      },
      { title = "Neotest Summary", ft = "neotest-summary" },
      {
        title = "Help",
        ft = "help",
        filter = function(buf)
          return vim.bo[buf].buftype == "help"
        end,
      },
    },
    right = {
      { title = "Grug Far", ft = "grug-far", size = { width = 0.30 } },
    },
  })
  vim.keymap.set("n", "<leader>uE", function()
    require("edgy").toggle()
  end, { desc = "Edgy Toggle" })
  vim.keymap.set("n", "<A-w>", function()
    require("edgy").select()
  end, { desc = "Edgy Select Window" })
end)

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
