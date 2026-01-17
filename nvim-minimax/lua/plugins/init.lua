local plugin_specs = {}

-- Auto-import all modules in lua/plugins/*.lua (except init.lua)
local plugin_dir = vim.fn.stdpath('config') .. '/lua/plugins'
local plugin_files = vim.fn.globpath(plugin_dir, '*.lua', true, true)

table.sort(plugin_files)

for _, file in ipairs(plugin_files) do
  local name = vim.fn.fnamemodify(file, ':t:r')
  if name ~= 'init' then
    table.insert(plugin_specs, { import = 'plugins.' .. name })
  end
end

return plugin_specs
