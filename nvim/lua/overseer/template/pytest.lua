local function get_pytest_nodeid()
  local node = vim.treesitter.get_node()
  local test_func, test_class

  while node do
    local t = node:type()

    if t == "function_definition" then
      local name_node = node:field("name")[1]
      if name_node then
        local name = vim.treesitter.get_node_text(name_node, 0)
        if name:match("^test_") then
          test_func = name
        end
      end
    elseif t == "class_definition" then
      local name_node = node:field("name")[1]
      if name_node then
        local name = vim.treesitter.get_node_text(name_node, 0)
        if name:match("^Test") then
          test_class = name
        end
      end
    end

    node = node:parent()
  end

  local file = vim.fn.expand("%")
  if test_class and test_func then
    return string.format("%s::%s::%s", file, test_class, test_func)
  elseif test_func then
    return string.format("%s::%s", file, test_func)
  end
end

return {
  name = "Pytest current cursor",
  builder = function()
    local nodeid = get_pytest_nodeid()
    if not nodeid then
      vim.notify("No pytest test found at cursor", vim.log.levels.WARN)
      return
    end
    return {
      cmd = { "pytest", nodeid },
      components = {
        "default",
        "on_output_quickfix",
      },
    }
  end,
  condition = { filetype = { "python" } },
}
