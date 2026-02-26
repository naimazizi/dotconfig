return {
  {
    "vim-test/vim-test",
    config = function()
      -- Configure test runners
      vim.g["test#python#runner"] = "pytest"
      vim.g["test#rust#runner"] = "cargotest"

      -- Custom strategy using snacks terminal
      local function snacks_strategy(cmd)
        Snacks.terminal.open(cmd, {
          cwd = vim.uv.cwd(),
          start_insert = false,
          auto_close = false,
        })
      end

      vim.g["test#custom_strategies"] = {
        snacks = snacks_strategy,
      }
      vim.g["test#strategy"] = "snacks"
    end,
    -- stylua: ignore
    keys = {
      { "<leader>t", "", desc = "+test" },
      { "<leader>tr", "<cmd>TestNearest<CR>", desc = "Run Nearest Test" },
      { "<leader>tt", "<cmd>TestFile<CR>", desc = "Run File Tests" },
      { "<leader>tT", "<cmd>TestSuite<CR>", desc = "Run All Tests" },
      { "<leader>tl", "<cmd>TestLast<CR>", desc = "Run Last Test" },
      { "<leader>tv", "<cmd>TestVisit<CR>", desc = "Visit Last Test" },
    },
  },
}
