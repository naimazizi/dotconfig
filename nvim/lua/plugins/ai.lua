return {
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
  {
    "cursortab/cursortab.nvim",
    vscode = false,
    lazy = false, -- The server is already lazy loaded
    build = "cd server && go build",
    config = function()
      require("cursortab").setup({
        keymaps = {
          accept = false, -- <Tab> is driven by blink's keymap instead
          partial_accept = false, -- <S-Tab> is driven by blink's keymap instead
        },
        provider = {
          -- Qwen3.5-0.8B (fastest local, defaults to "inline")
          url = "http://localhost:8000",
          model = "mlx-community/Qwen3.5-0.8B-MLX-4bit",

          -- sweep-next-edit-0.5B/1.5B (fastest local)
          -- type = "sweep",
          -- url = "http://localhost:8000",
          -- model = "Chris-Kode/sweep-next-edit-1.5b-mlx",
        },
      })
    end,
  },
}
