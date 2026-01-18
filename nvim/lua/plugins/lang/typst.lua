vim.lsp.config("tinymist", {
  single_file_support = true, -- Fixes LSP attachment in non-Git directories
  settings = {
    formatterMode = "typstyle",
    semanticTokens = "enable",
  },
})

vim.lsp.enable({ "tinymist" })

return {
  {
    "chomosuke/typst-preview.nvim",
    vscode = false,
    event = "VeryLazy",
    cmd = { "TypstPreview", "TypstPreviewToggle", "TypstPreviewUpdate" },
    keys = {
      {
        "<leader>cp",
        ft = "typst",
        "<cmd>TypstPreviewToggle<cr>",
        desc = "Toggle Typst Preview",
      },
    },
    opts = {
      dependencies_bin = {
        tinymist = "tinymist",
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "tinymist", "typstyle" })
    end,
  },
}
