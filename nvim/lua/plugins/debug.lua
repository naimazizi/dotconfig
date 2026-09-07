if vim.g.vscode then
  return
end

---@type table<string, string|{ [1]: string, [2]: string?, [3]: string? }>
local dap_icon = {
  Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
  Breakpoint = " ",
  BreakpointCondition = " ",
  BreakpointRejected = { " ", "DiagnosticError" },
  LogPoint = ".>",
}

local function with_dap(fn)
  return function()
    local ok, dap = pcall(require, "dap")
    if not ok then
      vim.notify("nvim-dap not available")
      return
    end
    fn(dap)
  end
end

vim.pack.add({
  Config.gh("mfussenegger/nvim-dap"),
  Config.gh("igorlfs/nvim-dap-view"),
  Config.gh("stevearc/overseer.nvim"),
  Config.gh("nvim-lua/plenary.nvim"),
  Config.gh("mfussenegger/nvim-dap-python"),
  Config.gh("nvim-neotest/neotest"),
  Config.gh("mason-org/mason.nvim"),
  Config.gh("jay-babu/mason-nvim-dap.nvim"),
})

Config.later(function()
  local commands = {
    DapToggleBreakpoint = with_dap(function(dap)
      dap.toggle_breakpoint()
    end),
    DapBreakpointCondition = with_dap(function(dap)
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end),
    DapLogPoint = with_dap(function(dap)
      dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
    end),
    DapContinue = with_dap(function(dap)
      dap.continue()
    end),
    DapRunToCursor = with_dap(function(dap)
      dap.run_to_cursor()
    end),
    DapPause = with_dap(function(dap)
      dap.pause()
    end),
    DapStepInto = with_dap(function(dap)
      dap.step_into()
    end),
    DapStepOver = with_dap(function(dap)
      dap.step_over()
    end),
    DapStepOut = with_dap(function(dap)
      dap.step_out()
    end),
    DapRunLast = with_dap(function(dap)
      dap.run_last()
    end),
    DapReplToggle = with_dap(function(dap)
      dap.repl.toggle()
    end),
    DapTerminate = with_dap(function(dap)
      dap.terminate()
    end),
    DapUiToggle = function()
      require("dap-view").toggle()
    end,
  }
  for name, fn in pairs(commands) do
    vim.api.nvim_create_user_command(name, fn, {})
  end

  require("mason-nvim-dap").setup({
    automatic_installation = true,
    ensure_installed = require("utils.table").uniq({ "debugpy", "codelldb" }),
    handlers = {
      python = function() end,
    },
  })

  require("overseer").enable_dap()

  vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

  for name, icon in pairs(dap_icon) do
    if type(icon) == "table" then
      local text = icon[1]
      local texthl = icon[2] or "DiagnosticInfo"
      vim.fn.sign_define("Dap" .. name, { text = text, texthl = texthl, linehl = icon[3], numhl = icon[3] })
    elseif type(icon) == "string" then
      vim.fn.sign_define("Dap" .. name, { text = icon, texthl = "DiagnosticInfo" })
    end
  end

  local vscode_dap = require("dap.ext.vscode")
  local json = require("plenary.json")
  vscode_dap.json_decode = function(str)
    return vim.json.decode(json.json_strip_comments(str))
  end

  local dap, dv = require("dap"), require("dap-view")
  -- dap.defaults.fallback.force_external_terminal = true
  -- dap.defaults.fallback.terminal_win_cmd = "belowright new | resize 15"
  dv.setup({
    winbar = {
      default_section = "watches",
      controls = {
        enabled = true,
        position = "right",
      },
    },
    windows = {
      terminal = {
        hide = { "delve", "debugpy" },
      },
      anchor = function()
        local windows = vim.api.nvim_tabpage_list_wins(0)

        for _, win in ipairs(windows) do
          local bufnr = vim.api.nvim_win_get_buf(win)
          if vim.bo[bufnr].buftype == "terminal" then
            return win
          end
        end
      end,
    },
    virtual_text = {
      enabled = true,
    },
  })

  dap.listeners.before.attach["dap-view-config"] = function()
    dv.open()
  end
  dap.listeners.before.launch["dap-view-config"] = function()
    dv.open()
  end
  dap.listeners.before.event_terminated["dap-view-config"] = function()
    dv.close()
  end
  dap.listeners.before.event_exited["dap-view-config"] = function()
    dv.close()
  end

  local map = vim.keymap.set
  map("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", { desc = "Toggle breakpoint" })
  map("n", "<leader>dB", "<cmd>DapBreakpointCondition<CR>", { desc = "Breakpoint condition" })
  map("n", "<leader>dL", "<cmd>DapLogPoint<CR>", { desc = "Log point" })
  map("n", "<leader>dc", "<cmd>DapContinue<CR>", { desc = "Continue" })
  map("n", "<leader>dC", "<cmd>DapRunToCursor<CR>", { desc = "Run to cursor" })
  map("n", "<leader>dp", "<cmd>DapPause<CR>", { desc = "Pause" })
  map("n", "<leader>di", "<cmd>DapStepInto<CR>", { desc = "Step into" })
  map("n", "<leader>do", "<cmd>DapStepOver<CR>", { desc = "Step over" })
  map("n", "<leader>dO", "<cmd>DapStepOut<CR>", { desc = "Step out" })
  map("n", "<leader>dl", "<cmd>DapRunLast<CR>", { desc = "Run last" })
  map("n", "<leader>dr", "<cmd>DapReplToggle<CR>", { desc = "Toggle REPL" })
  map("n", "<leader>dt", "<cmd>DapTerminate<CR>", { desc = "Terminate" })
  map("n", "<leader>du", "<cmd>DapUiToggle<CR>", { desc = "DAP UI" })
  map("n", "<leader>td", function()
    require("neotest").run.run({ strategy = "dap" })
  end, { desc = "Debug Nearest" })
end)

Config.on_filetype("python", function()
  require("dap-python").setup("debugpy-adapter")
end)
