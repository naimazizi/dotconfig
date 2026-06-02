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
  config = function()
    local engine = "luasnip"
    if vim.g.vscode then
      engine = "nvim"
    end

    require("neogen").setup({
      enabled = true,
      snippet_engine = engine,
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
  end,
}
