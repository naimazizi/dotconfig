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

---Find the function name at current cursor using treesitter
---@return string|nil name The function name
local function find_function_name()
  local ok, ts = pcall(require, "vim.treesitter")
  if not ok then
    return nil
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local parser = ts.get_parser(bufnr)
  if not parser then
    return nil
  end

  local root = parser:parse()[1]:root()
  local cursor_row = vim.fn.line(".") - 1

  -- Find the function definition node at cursor
  local function find_function(node)
    if not node then
      return nil
    end

    local start_row, _start_col, end_row, _end_col = node:range()

    -- Check if cursor is within this node's range
    if not (start_row <= cursor_row and cursor_row <= end_row) then
      return nil
    end

    local node_type = node:type()

    -- If this is a function/method, check children first for inner functions
    if node_type == "function_definition" or node_type == "method_definition" then
      -- Search children for a more specific (inner) function
      for child in node:iter_children() do
        local result = find_function(child)
        if result then
          return result
        end
      end

      -- No inner function found, this is the target - get its name
      for child in node:iter_children() do
        if child:type() == "identifier" then
          return vim.treesitter.get_node_text(child, bufnr)
        end
      end
    else
      -- Not a function node, search children
      for child in node:iter_children() do
        local result = find_function(child)
        if result then
          return result
        end
      end
    end

    return nil
  end

  return find_function(root)
end

---Debug test class for the current position
local function debug_method()
  local ok, dap = pcall(require, "dap")
  if not ok then
    vim.notify("nvim-dap not available")
    return
  end

  local ft = vim.bo.filetype

  -- Language-specific handlers
  local handlers = {
    python = function()
      -- Find the function name using treesitter
      local test_name = find_function_name()
      if not test_name then
        vim.notify("No function found at cursor")
        return
      end

      -- Get the current file path
      local file_path = vim.fn.expand("%:p")

      -- Run pytest with the specific test
      local pytest_args = { "-xvs", file_path .. "::" .. test_name }

      -- Configure and start debugging
      if type(dap.run) == "function" then
        dap.run({
          type = "python",
          name = "pytest: " .. test_name,
          request = "launch",
          module = "pytest",
          args = pytest_args,
          console = "integratedTerminal",
          justMyCode = false,
        })
      else
        vim.notify("dap.run not available")
      end
    end,
    rust = function()
      vim.cmd("RustLsp debuggables")
    end,
  }

  -- Execute language-specific handler or fallback
  local handler = handlers[ft]
  if handler then
    handler()
  else
    -- Fallback for unsupported languages
    vim.notify("Test class debugging not configured for " .. ft)
    if type(dap.continue) == "function" then
      dap.continue()
    end
  end
end

return {
  {
    "mfussenegger/nvim-dap",
    vscode = false,
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
        function()
          require("dap-view").toggle()
        end,
        desc = "DAP UI",
      },
      {
        "<leader>dm",
        function()
          debug_method()
        end,
        desc = "Debug test method",
      },
    },
    dependencies = {
      "igorlfs/nvim-dap-view",
      "stevearc/overseer.nvim",
      { "nvim-lua/plenary.nvim", lazy = true },
      {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        event = { "BufReadPre", "BufNewFile" },
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
