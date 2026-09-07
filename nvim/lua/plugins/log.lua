if vim.g.vscode then
  return
end

vim.pack.add({ Config.gh("minigian/juan-logs.nvim") })

Config.on_packchanged("juan-logs.nvim", { "install", "update" }, function(data)
  local buildfile = data.path .. "/build.lua"
  if vim.uv.fs_stat(buildfile) then
    dofile(buildfile)
  end
end, "Run juan-logs.nvim build.lua")

Config.on_filetype("log,txt,csv,json,tsv", function()
  require("juanlog").setup({
    threshold_size = 1024 * 1024 * 10, -- 10MB
    mode = "dynamic",
    lazy = true,
    patterns = { "*.log", "*.txt", "*.csv", "*.json", "*.tsv" },
    enable_custom_statuscol = true,
    syntax = true, -- set to true to enable native vim syntax (can be slow on huge files)
  })
end)
