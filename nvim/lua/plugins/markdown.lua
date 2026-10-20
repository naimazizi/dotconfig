if vim.g.vscode then
  return
end

vim.pack.add({
  Config.gh("MeanderingProgrammer/render-markdown.nvim"),
  Config.gh("kevalin/mermaid.nvim"),
  Config.gh("nvim-treesitter/nvim-treesitter"),
  Config.gh("selimacerbas/kitehost.nvim"),
  Config.gh("selimacerbas/mdkite.nvim"),
})

Config.on_filetype(table.concat(vim.g.md_ft, ","), function()
  require("render-markdown").setup({
    render_modes = true,
    file_types = vim.g.md_ft,
    code = {
      style = "full",
      width = "full",
    },
  })

  require("mermaid").setup()

  require("mdkite").setup({
    -- all optional; sane defaults shown
    instance_mode = "takeover", -- "takeover" (one tab) or "multi" (tab per instance)
    port = 0, -- 0 = auto (8421 for takeover, OS-assigned for multi)
    open_browser = true,
    default_theme = "dark", -- "dark" or "light"; initial preview theme
    debounce_ms = 300,
    mermaid_renderer = "rust",
  })
end)
