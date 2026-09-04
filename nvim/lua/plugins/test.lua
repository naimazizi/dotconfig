return {
  {
    "nvim-neotest/neotest",
    cmd = {
      "NeotestAttach",
      "NeotestFile",
      "NeotestSuite",
      "NeotestNearest",
      "NeotestLast",
      "NeotestSummary",
      "NeotestOutput",
      "NeotestOutputPanel",
      "NeotestStop",
      "NeotestWatch",
    },
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
