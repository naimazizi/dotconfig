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
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MeanderingProgrammer/render-markdown.nvim",
      "saghen/blink.cmp",
    },
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "copilot-language-server" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    config = function()
      vim.lsp.enable("copilot")
    end,
  },
}
