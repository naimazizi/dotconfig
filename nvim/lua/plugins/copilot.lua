return {
  {
    "copilotlsp-nvim/copilot-lsp",
    event = "BufRead",
    cond = function()
      return vim.g.copilot_nes_enabled ~= false
    end,
    vscode = false,
    config = function()
      require("copilot-lsp").setup({
        nes = {
          move_count_threshold = 2,
          distance_threshold = 10,
          clear_on_large_distance = true,
          count_horizontal_moves = true,
          reset_on_approaching = true,
        },
      })
      vim.g.copilot_nes_debounce = 250
      vim.lsp.enable("copilot_ls")
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    cond = function()
      return vim.g.copilot_nes_enabled ~= true
    end,
    vscode = false,
    opts = {
      suggestion = {
        enabled = not vim.g.ai_cmp,
        auto_trigger = true,
        hide_during_completion = vim.g.ai_cmp,
        keymap = {
          accept = false, -- handled by nvim-cmp / blink.cmp
        },
      },
      panel = { enabled = false },
    },
  },
  {
    "dlants/magenta.nvim",
    event = "BufRead",
    build = "npm install --frozen-lockfile",
    vscode = false,
    config = function()
      require("magenta").setup({
        profiles = {
          {
            name = "copilot-gpt",
            provider = "copilot",
            model = "gpt-4.1",
          },
        },
        -- open chat sidebar on left or right side
        sidebarPosition = "right",
        -- can be changed to "telescope" or "snacks"
        picker = "snacks",
        -- enable default keymaps shown below
        defaultKeymaps = false,
        -- maximum number of sub-agents that can run concurrently (default: 3)
        maxConcurrentSubagents = 1,
        -- glob patterns for files that should be auto-approved for getFile tool
        -- (bypasses user approval for hidden/gitignored files matching these patterns)
        getFileAutoAllowGlobs = { "node_modules/*" }, -- default includes node_modules
        -- keymaps for the sidebar input buffer
        sidebarKeymaps = {
          normal = {
            ["<CR>"] = ":Magenta send<CR>",
          },
        },
        -- keymaps for the inline edit input buffer
        -- if keymap is set to function, it accepts a target_bufnr param
        inlineKeymaps = {
          normal = {
            ["<CR>"] = function(target_bufnr)
              vim.cmd("Magenta submit-inline-edit " .. target_bufnr)
            end,
          },
        },
        -- configure edit prediction options
        editPrediction = {
          -- Use a dedicated profile for predictions (optional)
          -- If not specified, uses the current active profile's model
          profile = {
            name = "copilot",
            provider = "copilot",
            model = "gpt-4.1",
          },
          -- Maximum number of changes to track for context (default: 10)
          changeTrackerMaxChanges = 20,
          -- Token budget for including recent changes (default: 1000)
          recentChangeTokenBudget = 1500,
          -- Customize the system prompt (optional)
          -- systemPrompt = "Your custom prediction system prompt here...",
          -- Add instructions to the default system prompt (optional)
          systemPromptAppend = "Focus on completing function calls and variable declarations.",
        },
      })

      require("which-key").add({
        { "<leader>m", hidden = true },
      })

      -- Edit prediction
      vim.keymap.set(
        "i",
        "<localleader><localleader>",
        "<Cmd>Magenta predict-edit<CR>",
        { silent = true, noremap = true, desc = "Next Edit Prediction (NES) - Magenta" }
      )

      vim.keymap.set(
        "n",
        "<localleader><localleader>",
        "<Cmd>Magenta predict-edit<CR>",
        { silent = true, noremap = true, desc = "Next Edit Prediction (NES) - Magenta" }
      )
    end,
  },
}
