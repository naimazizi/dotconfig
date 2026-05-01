return {
  {
    "vim-test/vim-test",
    config = function()
      -- Configure test runners
      vim.g["test#python#runner"] = "pytest"
      vim.g["test#rust#runner"] = "cargotest"

      -- Custom strategy using snacks terminal
      local function snacks_strategy(cmd)
        for _, terminal in ipairs(Snacks.terminal.list()) do
          local win = terminal.win
          local buf = terminal.buf
          ---@diagnostic disable-next-line: param-type-mismatch
          if
            type(buf) == "number"
            and type(win) == "number"
            and vim.api.nvim_buf_is_valid(buf)
            and vim.api.nvim_win_is_valid(win)
          then
            ---@type integer?
            local job_id = vim.b[buf].terminal_job_id
            if job_id and vim.fn.jobwait({ job_id }, 0)[1] == -1 then
              vim.fn.chansend(job_id, "\x15" .. cmd .. "\n")
              ---@diagnostic disable-next-line: param-type-mismatch
              vim.api.nvim_win_call(win, function()
                vim.cmd("normal! G")
              end)
              return
            end
          end
        end

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
