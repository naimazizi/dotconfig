return {
  {
    "gitsigns.nvim",
    vscode = false,
    -- change some options
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text_pos = "right_align",
        delay = 100,
      },
    },
  },
}
