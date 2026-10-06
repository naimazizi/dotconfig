if vim.g.vscode then
  return
end

vim.pack.add({
  Config.gh("noisesfromspace/touchup.nvim"),
  Config.gh("kevalin/mermaid.nvim"),
  Config.gh("nvim-treesitter/nvim-treesitter"),
  Config.gh("selimacerbas/kitehost.nvim"),
  Config.gh("selimacerbas/mdkite.nvim"),
})

Config.on_filetype(table.concat(vim.g.md_ft, ","), function()
  require("touchup").setup({
    filetypes = vim.g.md_ft,
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
