if vim.g.vscode then
  return
end

vim.g.barbar_auto_setup = false

vim.pack.add({ Config.gh("romgrk/barbar.nvim"), Config.gh("nvim-mini/mini.nvim") })

Config.now(function()
  require("barbar").setup({
    icons = {
      -- preset = "powerline",
      pinned = { button = "", filename = true },
      alternate = { filetype = { enabled = true } },
      diagnostics = {
        [vim.diagnostic.severity.ERROR] = { enabled = true, icon = "󰅚 " },
        [vim.diagnostic.severity.WARN] = { enabled = true, icon = " " },
        [vim.diagnostic.severity.INFO] = { enabled = false, icon = " " },
        [vim.diagnostic.severity.HINT] = { enabled = true, icon = " " },
      },
    },
    animation = false,
  })

  local map = vim.keymap.set
  map("n", "<S-h>", function()
    vim.cmd("BufferPrevious")
  end, { desc = "Buffer Previous", noremap = true, silent = true })
  map("n", "<S-l>", function()
    vim.cmd("BufferNext")
  end, { desc = "Buffer Next", noremap = true, silent = true })
  map("n", "[b", function()
    vim.cmd("BufferMovePrevious")
  end, { desc = "Buffer Move Previous", noremap = true, silent = true })
  map("n", "]b", function()
    vim.cmd("BufferMoveNext")
  end, { desc = "Buffer Move Next", noremap = true, silent = true })
  map("n", "<leader>bp", function()
    vim.cmd("BufferPin")
  end, { desc = "Buffer Pin", noremap = true, silent = true })
  map("n", "<leader>bP", function()
    vim.cmd("BufferCloseAllButCurrentOrPinned")
  end, { desc = "Buffer Close Unpinned", noremap = true, silent = true })
  map("n", "<leader>bh", function()
    vim.cmd("BufferCloseBuffersLeft")
  end, { desc = "Buffer Delete to Left", noremap = true, silent = true })
  map("n", "<leader>bl", function()
    vim.cmd("BufferCloseBuffersRight")
  end, { desc = "Buffer Delete to Right", noremap = true, silent = true })
  map("n", "<leader>bd", function()
    vim.cmd("BufferClose")
  end, { desc = "Buffer Close", noremap = true, silent = true })
  map("n", "<leader>bD", function()
    vim.cmd("BufferRestore")
  end, { desc = "Buffer Restore", noremap = true, silent = true })
  map("n", "<leader>bi", function()
    vim.cmd("BufferCloseAllButCurrentOrPinned")
  end, { desc = "Buffer Close All", noremap = true, silent = true })
  for i = 1, 9 do
    map("n", "<A-" .. i .. ">", function()
      vim.cmd("BufferGoto " .. i)
    end, { desc = "Buffer " .. i, noremap = true, silent = true })
  end
  map("n", "<A-0>", function()
    vim.cmd("BufferLast")
  end, { desc = "Buffer Last", noremap = true, silent = true })
end)
