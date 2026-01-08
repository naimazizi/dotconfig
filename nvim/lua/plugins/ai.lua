return {
  {
    "sudo-tee/opencode.nvim",
    event = "VeryLazy",
    vscode = false,
    cmd = "Opencode",
    config = function()
      require("opencode").setup({
        preferred_picker = "fzf", -- 'telescope', 'fzf', 'mini.pick', 'snacks', 'select', if nil, it will use the best available picker. Note mini.pick does not support multiple selections
        preferred_completion = "blink",
        default_global_keymaps = true,
        default_mode = "build",
        keymap_prefix = "<leader>a",
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MeanderingProgrammer/render-markdown.nvim",
      "saghen/blink.cmp",
      "ibhagwan/fzf-lua",
    },
  },
}
