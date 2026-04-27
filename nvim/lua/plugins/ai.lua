return {
  {
    "sudo-tee/opencode.nvim",
    event = "VeryLazy",
    vscode = false,
    cmd = "Opencode",
    config = function()
      require("opencode").setup({
        preferred_picker = "telescope", -- 'telescope', 'fzf', 'mini.pick', 'snacks', 'select', if nil, it will use the best available picker. Note mini.pick does not support multiple selections
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
}
