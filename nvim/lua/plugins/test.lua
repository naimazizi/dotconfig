if vim.g.vscode then
  return
end

vim.pack.add({
  Config.gh("nvim-neotest/neotest"),
  Config.gh("nvim-neotest/nvim-nio"),
  Config.gh("stevearc/overseer.nvim"),
  -- Adapters contributed by language-specific files
  Config.gh("nvim-neotest/neotest-python"),
  Config.gh("mrcjkb/rustaceanvim"),
})

Config.later(function()
  local opts = {
    adapters = {
      ["neotest-python"] = {},
      ["rustaceanvim.neotest"] = {},
    },
    status = { virtual_text = true },
    output = { open_on_run = true },
    quickfix = {
      open = function()
        vim.cmd("copen")
      end,
    },
  }

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

  opts.consumers = {
    overseer = require("neotest.consumers.overseer"),
  }

  local adapters = {}
  for name, config in pairs(opts.adapters or {}) do
    if type(name) == "number" then
      if type(config) == "string" then
        config = require(config)
      end
      adapters[#adapters + 1] = config
      ---@diagnostic disable-next-line
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

  local map = vim.keymap.set
  map("n", "<leader>ta", "<cmd>NeotestAttach<CR>", { desc = "Attach to Test (Neotest)" })
  map("n", "<leader>tt", "<cmd>NeotestFile<CR>", { desc = "Run File (Neotest)" })
  map("n", "<leader>tT", "<cmd>NeotestSuite<CR>", { desc = "Run All Test Files (Neotest)" })
  map("n", "<leader>tr", "<cmd>NeotestNearest<CR>", { desc = "Run Nearest (Neotest)" })
  map("n", "<leader>tl", "<cmd>NeotestLast<CR>", { desc = "Run Last (Neotest)" })
  map("n", "<leader>ts", "<cmd>NeotestSummary<CR>", { desc = "Toggle Summary (Neotest)" })
  map("n", "<leader>to", "<cmd>NeotestOutput<CR>", { desc = "Show Output (Neotest)" })
  map("n", "<leader>tO", "<cmd>NeotestOutputPanel<CR>", { desc = "Toggle Output Panel (Neotest)" })
  map("n", "<leader>tS", "<cmd>NeotestStop<CR>", { desc = "Stop (Neotest)" })
  map("n", "<leader>tw", "<cmd>NeotestWatch<CR>", { desc = "Toggle Watch (Neotest)" })
end)
