return {
  "danymat/neogen",
  vscode = true,
  cmd = "Neogen",
  keys = {
    {
      "<leader>cn",
      function()
        require("neogen").generate()
      end,
      desc = "Generate Annotations (Neogen)",
    },
  },
  opts = function()
    return {
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
    }
  end,
}
