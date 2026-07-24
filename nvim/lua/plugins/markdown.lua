return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    vscode = false,
    ft = vim.g.md_ft,
    opts = {
      render_modes = true, -- enable all modes
      file_types = vim.g.md_ft,
      code = {
        style = "full",
        width = "full",
      },
    },
  },
  {
    "kevalin/mermaid.nvim",
    event = "VeryLazy",
    vscode = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("mermaid").setup()
    end,
  },
  {
    "selimacerbas/markdown-preview.nvim",
    event = "VeryLazy",
    vscode = false,
    dependencies = { "selimacerbas/live-server.nvim" },
    config = function()
      require("markdown_preview").setup({
        -- all optional; sane defaults shown
        instance_mode = "takeover", -- "takeover" (one tab) or "multi" (tab per instance)
        port = 0, -- 0 = auto (8421 for takeover, OS-assigned for multi)
        open_browser = true,
        default_theme = "dark", -- "dark" or "light"; initial preview theme
        debounce_ms = 300,
      })
    end,
  },
}
