return {
  name = "Pytest current file",
  builder = function()
    local file = vim.fn.expand("%")
    if not file or file == "" then
      vim.notify("No file open", vim.log.levels.WARN)
      return
    end
    return {
      cmd = { "pytest", file, "-v" },
      components = {
        "default",
        "on_output_quickfix",
      },
    }
  end,
  condition = { filetype = { "python" } },
}
