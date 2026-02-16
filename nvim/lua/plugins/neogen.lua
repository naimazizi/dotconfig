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
  opts = function(_, opts)
    if not vim.g.vscode then
      opts.snippet_engine = "luasnip"
    end
    require("neogen").setup({
      enabled = true,
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
