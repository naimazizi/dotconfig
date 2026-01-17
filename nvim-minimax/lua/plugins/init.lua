local plugin_specs = {}

-- Auto-import all modules in lua/plugins/*.lua (except init.lua)
local plugin_dir = vim.fn.stdpath("config") .. "/lua/plugins"
local plugin_files = vim.fn.globpath(plugin_dir, "*.lua", true, true)

table.sort(plugin_files)

for _, file in ipairs(plugin_files) do
  local name = vim.fn.fnamemodify(file, ":t:r")
  if name ~= "init" then
    table.insert(plugin_specs, { import = "plugins." .. name })
  end
end

local lang_plugin_dir = plugin_dir .. "/lang"
local plugin_lang_files = vim.fn.globpath(lang_plugin_dir, "*.lua", true, true)

for _, file in ipairs(plugin_lang_files) do
  local name = vim.fn.fnamemodify(file, ":t:r")
  if name ~= "init" then
    table.insert(plugin_specs, { import = "plugins.lang." .. name })
  end
end

return plugin_specs
