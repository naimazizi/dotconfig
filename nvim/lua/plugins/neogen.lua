vim.pack.add({ Config.gh("danymat/neogen") })

Config.later(function()
  require("neogen").setup({
    enabled = true,
    snippet_engine = vim.g.vscode and "nvim" or "luasnip",
    languages = {
      lua = {
        template = {
          annotation_convention = "emmylua", -- for a full list of annotation_conventions, see supported-languages below,
        },
      },
      python = {
        template = {
          annotation_convention = "google_docstrings",
        },
      },
    },
  })

  vim.keymap.set("n", "<leader>cn", function()
    require("neogen").generate()
  end, { desc = "Generate Annotations (Neogen)" })
end)
