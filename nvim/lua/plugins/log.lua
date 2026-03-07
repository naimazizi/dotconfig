return {
  {
    "minigian/juan-logs.nvim",
    vscode = false,
    build = function(plugin)
      local path = plugin.dir .. "/build.lua"
      if vim.fn.filereadable(path) == 1 then
        dofile(path)
      end
    end,
    config = function()
      require("juanlog").setup({
        threshold_size = 1024 * 1024 * 10, -- 10MB
        mode = "dynamic",
        lazy = true,
        patterns = { "*.log", "*.txt", "*.csv", "*.json", "*.tsv" },
        enable_custom_statuscol = true,
        syntax = true, -- set to true to enable native vim syntax (can be slow on huge files)
      })
    end,
  },
}
