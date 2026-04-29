return {
  {
    "romgrk/barbar.nvim",
    vscode = false,
    event = "BufReadPre",
    dependencies = {
      "nvim-mini/mini.nvim",
    },
    keys = {
      { "<S-h>", "<Cmd>BufferPrevious<CR>", desc = "Buffer Previous", noremap = true, silent = true },
      { "<S-l>", "<Cmd>BufferNext<CR>", desc = "Buffer Next", noremap = true, silent = true },
      { "[b", "<Cmd>BufferMovePrevious<CR>", desc = "Buffer Move Previous", noremap = true, silent = true },
      { "]b", "<Cmd>BufferMoveNext<CR>", desc = "Buffer Move Next", noremap = true, silent = true },
      { "<leader>bp", "<Cmd>BufferPin<CR>", desc = "Buffer Pin", noremap = true, silent = true },
      {
        "<leader>bP",
        "<Cmd>BufferCloseAllButCurrentOrPinned<CR>",
        desc = "Buffer Close Unpinned",
        noremap = true,
        silent = true,
      },
      {
        "<leader>bh",
        "<Cmd>BufferCloseBuffersLeft<CR>",
        desc = "Buffer Delete to Left",
        noremap = true,
        silent = true,
      },
      {
        "<leader>bl",
        "<Cmd>BufferCloseBuffersRight<CR>",
        desc = "Buffer Delete to Right",
        noremap = true,
        silent = true,
      },
      { "<A-1>", "<Cmd>BufferGoto 1<CR>", desc = "Buffer 1", noremap = true, silent = true },
      { "<A-2>", "<Cmd>BufferGoto 2<CR>", desc = "Buffer 2", noremap = true, silent = true },
      { "<A-3>", "<Cmd>BufferGoto 3<CR>", desc = "Buffer 3", noremap = true, silent = true },
      { "<A-4>", "<Cmd>BufferGoto 4<CR>", desc = "Buffer 4", noremap = true, silent = true },
      { "<A-5>", "<Cmd>BufferGoto 5<CR>", desc = "Buffer 5", noremap = true, silent = true },
      { "<A-6>", "<Cmd>BufferGoto 6<CR>", desc = "Buffer 6", noremap = true, silent = true },
      { "<A-7>", "<Cmd>BufferGoto 7<CR>", desc = "Buffer 7", noremap = true, silent = true },
      { "<A-8>", "<Cmd>BufferGoto 8<CR>", desc = "Buffer 8", noremap = true, silent = true },
      { "<A-9>", "<Cmd>BufferGoto 9<CR>", desc = "Buffer 9", noremap = true, silent = true },
      { "<A-0>", "<Cmd>BufferLast<CR>", desc = "Buffer Last", noremap = true, silent = true },
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {
      icons = {
        preset = "powerline",
        pinned = { button = "", filename = true },
        alternate = { filetype = { enabled = true } },
        diagnostics = {
          [vim.diagnostic.severity.ERROR] = { enabled = true, icon = "󰅚 " },
          [vim.diagnostic.severity.WARN] = { enabled = true, icon = " " },
          [vim.diagnostic.severity.INFO] = { enabled = false, icon = " " },
          [vim.diagnostic.severity.HINT] = { enabled = true, icon = " " },
        },
      },
      animation = "false",
    },
  },
}
