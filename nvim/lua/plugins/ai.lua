return {
  {
    "milanglacier/minuet-ai.nvim",
    event = "InsertEnter",
    vscode = false,
    keys = {
      {
        "<A-z>",
        mode = { "i", "n" },
        "<cmd>Minuet duet predict<cr>",
        desc = "Minuet duet predict",
      },
      {
        "<A-a>",
        mode = { "i", "n" },
        "<cmd>Minuet duet apply<cr>",
        desc = "Minuet duet apply",
      },
      {
        "<A-Z>",
        mode = { "i", "n" },
        "<cmd>Minuet duet dismiss<cr>",
        desc = "Minuet duet dismiss",
      },
    },
    opts = {
      provider = "openai_compatible",
      request_timeout = 2,
      throttle = 500,
      debounce = 400,
      n_completions = 1,
      notify = "warn",
      blink = {
        enable_auto_complete = false,
      },
      provider_options = {
        openai_compatible = {
          name = "LiteLLM",
          end_point = vim.env.LITELLM_API_ENDPOINT .. "/chat/completions",
          api_key = "LITELLM_API_KEY",
          model = "claude-haiku-4.5",
          stream = true,
          optional = {
            max_tokens = 128,
            top_p = 0.9,
          },
        },
      },
      duet = {
        provider = "openai_compatible",
        request_timeout = 15,
        provider_options = {
          openai_compatible = {
            name = "LiteLLM",
            end_point = vim.env.LITELLM_API_ENDPOINT .. "/chat/completions",
            api_key = "LITELLM_API_KEY",
            model = "claude-haiku-4.5",
            optional = {},
          },
        },
      },
    },
  },
  {
    "carlos-algms/agentic.nvim",
    event = "VeryLazy",
    vscode = false,
    --- @type agentic.PartialUserConfig
    opts = {
      provider = "pi-acp",
      windows = {
        position = "right",
        width = "30%",
      },
      slash_commands = {
        auto_trigger = false,
      },
      file_picker = {
        auto_trigger = false,
      },
    },
    keys = {
      {
        "<leader>aa",
        function()
          require("agentic").toggle()
        end,
        mode = { "n", "v" },
        desc = "Toggle Agentic Chat",
      },
      {
        "<leader>as",
        function()
          require("agentic").add_selection_or_file_to_context()
        end,
        mode = { "n", "v" },
        desc = "Add file or selection to Agentic to Context",
      },
      {
        "<leader>ai",
        function()
          require("agentic").new_session()
        end,
        mode = { "n", "v" },
        desc = "New Agentic Session",
      },
      {
        "<leader>ar", -- ai Restore
        function()
          require("agentic").restore_session()
        end,
        desc = "Agentic Restore session",
        silent = true,
        mode = { "n", "v" },
      },
      {
        "<leader>ad", -- ai Diagnostics
        function()
          require("agentic").add_current_line_diagnostics()
        end,
        desc = "Add current line diagnostic to Agentic",
        mode = { "n" },
      },
      {
        "<leader>aD", -- ai all Diagnostics
        function()
          require("agentic").add_buffer_diagnostics()
        end,
        desc = "Add all buffer diagnostics to Agentic",
        mode = { "n" },
      },
    },
  },
  {
    "sudo-tee/opencode.nvim",
    enabled = false,
    vscode = false,
    cmd = "Opencode",
    keys = {
      {
        "<C-.>",
        mode = { "n", "v" },
        "<cmd>Opencode toggle<cr>",
        desc = "Opencode toggle",
      },
      {
        "<leader>ag",
        mode = { "n", "v" },
        "<cmd>Opencode toggle<cr>",
        desc = "Toggle Opencode window",
      },
      {
        "<leader>ai",
        mode = { "n", "v" },
        "<cmd>Opencode toggle<cr>",
        desc = "Open input window",
      },
    },
    opts = {
      preferred_picker = "snacks",
      preferred_completion = "blink",
      default_global_keymaps = true,
      default_mode = "build",
      keymap_prefix = "<leader>a",
      ui = {
        input = {
          min_height = 0.25,
          max_height = 0.25,
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "saghen/blink.cmp",
    },
  },
}
