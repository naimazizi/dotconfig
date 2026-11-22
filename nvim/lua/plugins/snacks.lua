if vim.g.vscode then
  return
end

vim.pack.add({ Config.gh("folke/snacks.nvim") })

Config.now(function()
  require("snacks").setup({
    image = { enabled = true },
    bigfile = { enabled = true },
    bufdelete = { enabled = true },
    indent = {
      enabled = true,
      indent = { char = "┊" },
      scope = { only_current = true },
      chunk = {
        enabled = true,
        only_current = true,
        char = { corner_top = "╭", corner_bottom = "╰" },
      },
    },
    quickfile = { enabled = true },
    rename = { enabled = true },
    gitbrowse = { enabled = true },
    scope = { enabled = true },
    scratch = { enabled = true },
    scroll = { enabled = true },
    terminal = { enabled = true },
    zen = {
      enabled = true,
      toggles = {
        dim = true,
        git_signs = true,
        mini_diff_signs = true,
        diagnostics = true,
        inlay_hints = true,
      },
    },
  })

  local map = vim.keymap.set
  map("n", "<leader>bd", function()
    Snacks.bufdelete()
  end, { desc = "Buffer Delete" })
  map("n", "<leader>bo", function()
    Snacks.bufdelete.other()
  end, { desc = "Buffer Delete Others" })
  map("n", "<leader>uz", function()
    Snacks.zen()
  end, { desc = "Toggle zen mode" })
  map("n", "<leader>cR", function()
    Snacks.rename.rename_file()
  end, { desc = "Rename file" })
  map({ "n", "x" }, "<leader>gB", function()
    Snacks.gitbrowse()
  end, { desc = "Git Browse" })
  map("n", "<leader>.", function()
    Snacks.scratch()
  end, { desc = "Toggle scratch buffer" })
  map("n", "<leader>bs", function()
    -- Snacks.scratch.select() uses Snacks picker even when it is disabled.
    vim.ui.select(Snacks.scratch.list(), {
      prompt = "Select scratch buffer",
      format_item = function(item)
        return table.concat({ item.name, item.ft, item.cwd or "", item.branch or "", item.file }, " ")
      end,
    }, function(item)
      if item then
        Snacks.scratch({ file = item.file } --[[@as snacks.scratch.Config]])
      end
    end)
  end, { desc = "Select scratch buffer" })
end)
