return {
  {
    "ibhagwan/fzf-lua",
    vscode = false,
    dependencies = {
      {
        "elanmed/fzf-lua-frecency.nvim",
        config = function()
          require("fzf-lua-frecency").setup({
            display_score = false,
            cwd_only = true,
            all_files = true,
          })
        end,
      },
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
      { "<leader>fr", "<cmd>:FzfLua frecency<CR>", desc = "Recent" },
      { "<leader><localleader>", "<cmd>:FzfLua global<CR>", desc = "Global Search" },
      { "<leader><leader>", "<cmd>:FzfLua frecency<CR>", desc = "Find Files (cwd by frecency)" },
      { "gai", "<cmd>:FzfLua lsp_incoming_calls<CR>", desc = "C[a]lls Incoming" },
      { "gao", "<cmd>:FzfLua lsp_outgoing_calls<CR>", desc = "C[a]lls Outgoing" },
    },
  },
}
