return {
  { "rcarriga/nvim-dap-ui", enabled = false, event = "VeryLazy" },
  -- {
  --   "miroshQa/debugmaster.nvim",
  --   -- osv is needed if you want to debug neovim lua code. Also can be used
  --   -- as a way to quickly test-drive the plugin without configuring debug adapters
  --   dependencies = { "mfussenegger/nvim-dap", "jbyuki/one-small-step-for-vimkind" },
  --   event = "VeryLazy",
  --   config = function()
  --     local dm = require("debugmaster")
  --     -- make sure you don't have any other keymaps that starts with "<leader>d" to avoid delay
  --     -- Alternative keybindings to "<leader>d" could be: "<leader>m", "<leader>;"
  --     vim.keymap.set({ "n", "v" }, "<leader>d", dm.mode.toggle, { nowait = true })
  --     -- If you want to disable debug mode in addition to leader+d using the Escape key:
  --     -- vim.keymap.set("n", "<Esc>", dm.mode.disable)
  --     -- This might be unwanted if you already use Esc for ":noh"
  --     vim.keymap.set("t", "<C-\\>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
  --
  --     dm.plugins.osv_integration.enabled = true -- needed if you want to debug neovim lua code
  --     local dap = require("dap")
  --     -- Configure your debug adapters here
  --     -- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
  --   end,
  -- },
  {
    "igorlfs/nvim-dap-view",
    event = "VeryLazy",
    vscode = false,
    config = function(_, opts)
      local dap, dv = require("dap"), require("dap-view")

      opts.winbar = {
        sections = { "scopes", "watches", "breakpoints", "exceptions", "repl", "threads" },
        -- Must be one of the sections declared above
        default_section = "scopes",
        controls = {
          enabled = true,
          buttons = { "play", "step_into", "step_over", "step_out", "term_restart" },
          custom_buttons = {
            -- Stop/Restart button
            -- Double click, middle click or click with a modifier disconnect instead of stop
            term_restart = {
              render = function()
                local session = dap.session()
                local group = session and "ControlTerminate" or "ControlRunLast"
                local icon = session and "" or ""
                return "%#NvimDapView" .. group .. "#" .. icon .. "%*"
              end,
              action = function(clicks, button, modifiers)
                local alt = clicks > 1 or button ~= "l" or modifiers:gsub(" ", "") ~= ""
                if not dap.session() then
                  dap.run_last()
                elseif alt then
                  dap.disconnect()
                else
                  dap.terminate()
                end
              end,
            },
          },
        },
      }

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

      vim.keymap.set("n", "<leader>du", function()
        dv.toggle()
      end, { desc = "Toggle DAP view" })
      vim.keymap.set("n", "<leader>d1", function()
        dv.jump_to_view("scopes")
      end, { desc = "Jump to Scopes" })
      vim.keymap.set("n", "<leader>d2", function()
        dv.jump_to_view("watches")
      end, { desc = "Jump to Watches" })
      vim.keymap.set("n", "<leader>d3", function()
        dv.jump_to_view("breakpoints")
      end, { desc = "Jump to Breakpoints" })
      vim.keymap.set("n", "<leader>d4", function()
        dv.jump_to_view("exceptions")
      end, { desc = "Jump to Exceptions" })
      vim.keymap.set("n", "<leader>d5", function()
        dv.jump_to_view("repl")
      end, { desc = "Jump to Repl" })

      -- delete keymap for dap Repl & widget
      vim.keymap.del("n", "<leader>dr")
      vim.keymap.del("n", "<leader>dw")

      dv.setup(opts)
    end,
  },
}
