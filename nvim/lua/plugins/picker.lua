return {
  {
    "ibhagwan/fzf-lua",
    vscode = false,
    opts = {
      { "telescope" },
      previewers = {},
    },
    keys = {
      { "<leader>dd", "<cmd>:FzfLua dap_breakpoints<CR>", desc = "List Breakpoints" },
      { "<leader>dv", "<cmd>:FzfLua dap_variables<CR>", desc = "List Variables" },
      { "<leader>fp", "<cmd>:FzfLua zoxide<CR>", desc = "Projects" },
      -- Disable keymap in favor of fff.nvim
      { "<leader><space>", false },
      { "<leader>ff", false },
      { "<leader>fF", false },
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
        "<leader>ff",
        function()
          require("fff").find_files()
        end,
        desc = "Find Files",
      },
      {
        "<leader>fF",
        function()
          require("fff").find_files()
        end,
        desc = "Find Files (cwd)",
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
