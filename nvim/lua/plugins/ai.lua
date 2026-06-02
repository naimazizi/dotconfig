return {
  {
    "sudo-tee/opencode.nvim",
    enabled = true,
    vscode = false,
    cmd = "Opencode",
    keys = {
      {
        "<leader>a",
        desc = "+AI",
      },
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
    config = function()
      require("opencode").setup({
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
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "saghen/blink.cmp",
    },
  },
  {
    "alex35mil/pi.nvim",
    enabled = false,
    event = "VeryLazy",
    vscode = false,
    keys = {
      {
        "<leader>aa",
        mode = { "n", "v" },
        function()
          vim.cmd("Pi layout=side")
        end,
        desc = "Pi side",
      },
      { "<leader>ac", mode = { "n", "v" }, "<Cmd>PiContinue<CR>", desc = "Pi continue last session" },
      { "<leader>ar", mode = { "n", "v" }, "<Cmd>PiResume<CR>", desc = "Pi resume past session" },
      { "<leader>af", mode = { "n", "v" }, "<Cmd>PiSendMention<CR>", desc = "Pi mention file/selection" },
      {
        "<leader>an",
        mode = { "n", "v" },
        "<Cmd>PiAttention<CR>",
        desc = "Pi open next attention request",
      },
    },
    opts = {
      diff = {
        keys = {
          accept = "<leader>aw",
          reject = "<leader>aq",
          expand_context = "<leader>ae",
          shrink_context = "<leader>as",
        },
      },
    },
  },
}
