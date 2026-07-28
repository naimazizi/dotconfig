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
          end_point = (vim.env.LITELLM_API_ENDPOINT or "") .. "/chat/completions",
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
            end_point = (vim.env.LITELLM_API_ENDPOINT or "") .. "/chat/completions",
            api_key = "LITELLM_API_KEY",
            model = "claude-haiku-4.5",
            optional = {},
          },
        },
      },
    },
  },
  {
    "sudo-tee/opencode.nvim",
    name = "opencode_tui",
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
  {
    "nickjvandyke/opencode.nvim",
    name = "opencode_gui",
    version = "*",
    keys = {
      {
        "<leader>aa",
        function()
          require("opencode").ask("@this: ")
        end,
        mode = { "n", "x" },
        desc = "Ask OpenCode…",
      },
      {
        "<leader>as",
        function()
          require("opencode").select()
        end,
        mode = { "n", "x" },
        desc = "Select OpenCode…",
      },
      {
        "<leader>aw",
        function()
          return require("opencode").operator("@this ")
        end,
        mode = { "x" },
        expr = true,
        desc = "Append range to OpenCode",
      },
      {
        "<leader>aw",
        function()
          return require("opencode").operator("@this ") .. "_"
        end,
        mode = "n",
        expr = true,
        desc = "Append line to OpenCode",
      },
      {
        "<S-C-u>",
        function()
          require("opencode").command("session.half.page.up")
        end,
        mode = "n",
        desc = "Scroll OpenCode up",
      },
      {
        "<S-C-d>",
        function()
          require("opencode").command("session.half.page.down")
        end,
        mode = "n",
        desc = "Scroll OpenCode down",
      },
    },
  },
}
