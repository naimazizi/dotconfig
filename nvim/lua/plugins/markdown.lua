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
}
