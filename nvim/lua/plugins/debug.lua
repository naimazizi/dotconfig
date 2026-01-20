local dap_icon = {
  Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
  Breakpoint = " ",
  BreakpointCondition = " ",
  BreakpointRejected = { " ", "DiagnosticError" },
  LogPoint = ".>",
}

return {
  {
    "mfussenegger/nvim-dap",
    event = { "BufReadPre", "BufNewFile" },
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
      -- no-op; keymaps live in lua/config/keymaps.lua
      require("mason-nvim-dap").setup({ handlers = {
        python = function() end,
      } })

      require("overseer").enable_dap()

      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(dap_icon) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
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
    keys = {
      {
        "<leader>du",
        function()
          require("dap-view").toggle()
        end,
        desc = "Dap UI",
      },
    },
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
