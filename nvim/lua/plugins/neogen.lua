return {
  "danymat/neogen",
  vscode = true,
  cmd = "Neogen",
  event = { "BufWritePre" },
  keys = {
    {
      "<leader>cn",
      function()
        require("neogen").generate()
      end,
      desc = "Generate Annotations (Neogen)",
    },
  },
  config = function()
    require("neogen").setup({
      enabled = true,
      snippet_engine = "luasnip" and not vim.g.vscode or nil,
      languages = {
        lua = {
          template = {
            annotation_convention = "emmylua", -- for a full list of annotation_conventions, see supported-languages below,
          },
        },
        python = {
          template = {
            annotation_conventions = "google_docstrings",
          },
        },
      },
    })
  end,
}
