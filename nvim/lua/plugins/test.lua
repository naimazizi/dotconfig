return {
  {
    "vim-test/vim-test",
    enabled = false,
    vscode = false,
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
  {
    "nvim-neotest/neotest",
    event = "VeryLazy",
    vscode = false,
    dependencies = { "nvim-neotest/nvim-nio", "stevearc/overseer.nvim" },
    opts = {
      adapters = {},
      status = { virtual_text = true },
      output = { open_on_run = true },
      quickfix = {
        open = function()
          vim.cmd("copen")
        end,
      },
    },
    config = function(_, opts)
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            -- Replace newline and tab characters with space for more compact diagnostics
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)

      opts.consumers = opts.consumers or {}
      opts.consumers = {
        overseer = require("neotest.consumers.overseer"),
      }

      if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters or {}) do
          if type(name) == "number" then
            if type(config) == "string" then
              config = require(config)
            end
            adapters[#adapters + 1] = config
          elseif config ~= false then
            local adapter = require(name)
            if type(config) == "table" and not vim.tbl_isempty(config) then
              local meta = getmetatable(adapter)
              if adapter.setup then
                adapter.setup(config)
              elseif adapter.adapter then
                adapter.adapter(config)
                adapter = adapter.adapter
              elseif meta and meta.__call then
                adapter = adapter(config)
              else
                error("Adapter " .. name .. " does not support setup")
              end
            end
            adapters[#adapters + 1] = adapter
          end
        end
        opts.adapters = adapters
      end

      require("neotest").setup(opts)

      local commands = {
        NeotestAttach = function()
          require("neotest").run.attach()
        end,
        NeotestFile = function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        NeotestSuite = function()
          require("neotest").run.run(vim.uv.cwd())
        end,
        NeotestNearest = function()
          require("neotest").run.run()
        end,
        NeotestLast = function()
          require("neotest").run.run_last()
        end,
        NeotestSummary = function()
          require("neotest").summary.toggle()
        end,
        NeotestOutput = function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        NeotestOutputPanel = function()
          require("neotest").output_panel.toggle()
        end,
        NeotestStop = function()
          require("neotest").run.stop()
        end,
        NeotestWatch = function()
          require("neotest").watch.toggle(vim.fn.expand("%"))
        end,
      }
      for name, fn in pairs(commands) do
        vim.api.nvim_create_user_command(name, fn, {})
      end
    end,
    keys = {
      { "<leader>t", "", desc = "+test" },
      { "<leader>ta", "<cmd>NeotestAttach<CR>", desc = "Attach to Test (Neotest)" },
      { "<leader>tt", "<cmd>NeotestFile<CR>", desc = "Run File (Neotest)" },
      { "<leader>tT", "<cmd>NeotestSuite<CR>", desc = "Run All Test Files (Neotest)" },
      { "<leader>tr", "<cmd>NeotestNearest<CR>", desc = "Run Nearest (Neotest)" },
      { "<leader>tl", "<cmd>NeotestLast<CR>", desc = "Run Last (Neotest)" },
      { "<leader>ts", "<cmd>NeotestSummary<CR>", desc = "Toggle Summary (Neotest)" },
      { "<leader>to", "<cmd>NeotestOutput<CR>", desc = "Show Output (Neotest)" },
      { "<leader>tO", "<cmd>NeotestOutputPanel<CR>", desc = "Toggle Output Panel (Neotest)" },
      { "<leader>tS", "<cmd>NeotestStop<CR>", desc = "Stop (Neotest)" },
      { "<leader>tw", "<cmd>NeotestWatch<CR>", desc = "Toggle Watch (Neotest)" },
    },
  },
}
