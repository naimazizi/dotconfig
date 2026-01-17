return {
  {
    "GCBallesteros/NotebookNavigator.nvim",
    enabled = false,
    vscode = false,
    dependencies = {
      "nvim-mini/mini.comment",
    },
    event = "BufRead *.py",
    config = function()
      local nn = require("notebook-navigator")
      vim.keymap.set({ "n", "v" }, "[r", function()
        nn.move_cell("u")
      end, { silent = true, desc = "Notebook - Move cell up" })
      vim.keymap.set({ "n", "v" }, "]r", function()
        nn.move_cell("d")
      end, { silent = true, desc = "Notebook - Move cell down" })
    end,
  },
  {
    "jpalardy/vim-slime",
    enabled = true,
    vscode = false,
    event = "BufRead *.py",
    init = function()
      vim.g.slime_no_mappings = 1
    end,
    keys = {
      { "<localleader>rC", "<cmd>SlimeConfig<cr>", desc = "Slime Config" },
      { "<localleader>rr", "<Plug>SlimeSendCell<BAR>/^# %%<CR>", desc = "Slime Send Cell" },
      { "<localleader>rr", ":<C-u>'<,'>SlimeSend<CR>", mode = "v", desc = "Slime Send Selection" },
      { "<localleader>r<cr>", "<Plug>SlimeLineSend<CR>", mode = "v", desc = "Slime Send Selection" },
    },
  },
}
