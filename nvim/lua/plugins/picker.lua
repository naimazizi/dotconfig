return {
  {
    "ibhagwan/fzf-lua",
    vscode = false,
    dependencies = {
      "folke/snacks.nvim",
    },
    opts = {
      { "telescope" },
      previewers = {},
    },
    keys = {
      { "<leader>dd", "<cmd>:FzfLua dap_breakpoints<CR>", desc = "List Breakpoints" },
      { "<leader>dv", "<cmd>:FzfLua dap_variables<CR>", desc = "List Variables" },
      { "<leader>fp", "<cmd>:FzfLua zoxide<CR>", desc = "Projects" },
      { "<leader><localleader>", "<cmd>:FzfLua global<CR>", desc = "Global Search" },
      { "gai", "<cmd>:FzfLua lsp_incoming_calls<CR>", desc = "C[a]lls Incoming" },
      { "gao", "<cmd>:FzfLua lsp_outgoing_calls<CR>", desc = "C[a]lls Outgoing" },
      -- Disable keymap in favor of fff.nvim
      { "<leader><space>", false },
      { "<leader>fg", false },
    },
  },
  {
    "dmtrKovalenko/fff.nvim",
    vscode = false,
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    opts = {
      prompt = " ",
      title = "Find Files",
    },
    lazy = false,
    keys = {
      {
        "<leader><space>",
        function()
          require("fff").find_files()
        end,
        desc = "Find Files",
      },
      {
        "<leader>fg",
        function()
          require("fff").find_in_git_root()
        end,
        desc = "Find Files (git-files)",
      },
    },
  },
}
