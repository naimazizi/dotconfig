if vim.g.vscode then
  return
end

vim.pack.add({
  { src = "https://github.com/sheng-tse/jupynvim", version = vim.version.range("*") },
})

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local d = ev.data
    if d.spec.name == "jupynvim" and (d.kind == "install" or d.kind == "update") then
      dofile(d.path .. "/lua/jupynvim/install.lua").run({ dir = d.path })
    end
  end,
})

Config.later(function()
  require("jupynvim").setup({})
end)
