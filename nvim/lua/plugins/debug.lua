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

return {
  {
    "mfussenegger/nvim-dap",
    vscode = false,
    lazy = true,
    keys = {
      { "<leader>db", "<cmd>DapToggleBreakpoint<CR>", desc = "Toggle breakpoint" },
      { "<leader>dB", "<cmd>DapBreakpointCondition<CR>", desc = "Breakpoint condition" },
      { "<leader>dL", "<cmd>DapLogPoint<CR>", desc = "Log point" },
      { "<leader>dc", "<cmd>DapContinue<CR>", desc = "Continue" },
      { "<leader>dC", "<cmd>DapRunToCursor<CR>", desc = "Run to cursor" },
      { "<leader>dp", "<cmd>DapPause<CR>", desc = "Pause" },
      { "<leader>di", "<cmd>DapStepInto<CR>", desc = "Step into" },
      { "<leader>do", "<cmd>DapStepOver<CR>", desc = "Step over" },
      { "<leader>dO", "<cmd>DapStepOut<CR>", desc = "Step out" },
      { "<leader>dl", "<cmd>DapRunLast<CR>", desc = "Run last" },
      { "<leader>dr", "<cmd>DapReplToggle<CR>", desc = "Toggle REPL" },
      { "<leader>dt", "<cmd>DapTerminate<CR>", desc = "Terminate" },
      { "<leader>du", "<cmd>DapUiToggle<CR>", desc = "DAP UI" },
      {
        "<leader>td",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Debug Nearest",
      },
    },
    dependencies = {
      "igorlfs/nvim-dap-view",
      "stevearc/overseer.nvim",
      { "nvim-lua/plenary.nvim", lazy = true },
      {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        config = function()
          require("dap-python").setup("debugpy-adapter")
        end,
      },
      "nvim-neotest/neotest",
    },
    config = function()
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

      require("mason-nvim-dap").setup({ handlers = {
        python = function() end,
      } })

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

      local vscode = require("dap.ext.vscode")
      local json = require("plenary.json")
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end
    end,
  },
  {
    "igorlfs/nvim-dap-view",
    vscode = false,
    lazy = true,
    ---@module 'dap-view'
    ---@type dapview.Config
    config = function()
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
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    vscode = false,
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = function(_, opts)
      opts = opts or {}
      opts.automatic_installation = true
      opts.handlers = opts.handlers or {}

      -- DAP adapter packages are NOT part of Mason's global ensure_installed.
      -- Manage them explicitly here so they reliably auto-install.
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "debugpy", "codelldb" })
      opts.ensure_installed = require("utils.table").uniq(opts.ensure_installed)

      return opts
    end,
    -- mason-nvim-dap is loaded when nvim-dap loads
  },
}
