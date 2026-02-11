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

local function with_dapui(fn)
  return function()
    local ok, dapui = pcall(require, "dapui")
    if not ok then
      vim.notify("nvim-dap-ui not available")
      return
    end
    fn(dapui)
  end
end

local function fzf_dap_picker(fn, opts)
  return function(...)
    local ok, fzf = pcall(require, "fzf-lua")
    if not ok then
      vim.notify("fzf-lua not available")
      return
    end
    if type(fzf[fn]) ~= "function" then
      vim.notify("fzf-lua picker not available")
      return
    end
    local merged_opts = vim.tbl_extend("force", opts or {}, select(1, ...) or {})
    return fzf[fn](merged_opts)
  end
end

return {
  {
    "mfussenegger/nvim-dap",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      {
        "<leader>db",
        with_dap(function(dap)
          dap.toggle_breakpoint()
        end),
        desc = "Toggle breakpoint",
      },
      {
        "<leader>dB",
        with_dap(function(dap)
          dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end),
        desc = "Breakpoint condition",
      },
      {
        "<leader>dL",
        with_dap(function(dap)
          dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
        end),
        desc = "Log point",
      },
      {
        "<leader>dc",
        with_dap(function(dap)
          dap.continue()
        end),
        desc = "Continue",
      },
      {
        "<leader>dC",
        with_dap(function(dap)
          dap.run_to_cursor()
        end),
        desc = "Run to cursor",
      },
      {
        "<leader>dp",
        with_dap(function(dap)
          dap.pause()
        end),
        desc = "Pause",
      },
      {
        "<leader>di",
        with_dap(function(dap)
          dap.step_into()
        end),
        desc = "Step into",
      },
      {
        "<leader>do",
        with_dap(function(dap)
          dap.step_over()
        end),
        desc = "Step over",
      },
      {
        "<leader>dO",
        with_dap(function(dap)
          dap.step_out()
        end),
        desc = "Step out",
      },
      {
        "<leader>dl",
        with_dap(function(dap)
          dap.run_last()
        end),
        desc = "Run last",
      },
      {
        "<leader>dr",
        with_dap(function(dap)
          dap.repl.toggle()
        end),
        desc = "Toggle REPL",
      },
      {
        "<leader>dt",
        with_dap(function(dap)
          dap.terminate()
        end),
        desc = "Terminate",
      },
      {
        "<leader>du",
        with_dapui(function(dapui)
          dapui.toggle()
        end),
        desc = "DAP UI",
      },
      {
        "<leader>de",
        with_dapui(function(dapui)
          dapui.eval()
        end),
        mode = { "n", "v" },
        desc = "Eval",
      },
      { "<leader>dd", fzf_dap_picker("dap_commands", {}), desc = "DAP commands" },
      { "<leader>dv", fzf_dap_picker("dap_variables", {}), desc = "DAP variables" },
      { "<leader>dV", fzf_dap_picker("dap_breakpoints", {}), desc = "DAP breakpoint" },
      { "<leader>df", fzf_dap_picker("dap_configurations", {}), desc = "Configuration" },
    },
    dependencies = {
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
      {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        event = { "BufReadPre", "BufNewFile" },
        keys = {
          {
            "<leader>dPt",
            function()
              require("dap-python").test_method()
            end,
            desc = "Debug Method",
            ft = "python",
          },
          {
            "<leader>dPc",
            function()
              require("dap-python").test_class()
            end,
            desc = "Debug Class",
            ft = "python",
          },
        },
        config = function()
          require("dap-python").setup("debugpy-adapter")
        end,
      },
    },
    config = function()
      require("mason-nvim-dap").setup({ handlers = {
        python = function() end,
      } })

      require("overseer").enable_dap()

      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, icon in pairs(dap_icon) do
        if type(icon) == "table" then
          local text = icon[1]
          if text then
            local texthl = icon[2] or "DiagnosticInfo"
            vim.fn.sign_define("Dap" .. name, { text = text, texthl = texthl, linehl = icon[3], numhl = icon[3] })
          end
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
    event = { "BufReadPre" },
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

      -- Keep the list stable & unique.
      local seen = {}
      local out = {}
      for _, item in ipairs(opts.ensure_installed) do
        if type(item) == "string" and item ~= "" and not seen[item] then
          seen[item] = true
          table.insert(out, item)
        end
      end
      table.sort(out)
      opts.ensure_installed = out

      return opts
    end,
    -- mason-nvim-dap is loaded when nvim-dap loads
    config = function() end,
  },
}
