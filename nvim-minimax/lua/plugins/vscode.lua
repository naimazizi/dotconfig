return {
  {
    "vscode-neovim/vscode-multi-cursor.nvim",
    event = "VeryLazy",
    vscode = true,
    opts = {
      -- Whether to set default mappings
      default_mappings = true,
      -- If set to true, only multiple cursors will be created without multiple selections
      no_selection = false,
    },
  },
  {
    "RRethy/vim-illuminate",
    vscode = true,
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp", "treesitter", "regex" },
      },
    },
  },
  {
    "danymat/neogen",
    vscode = true,
  },
}
