-- Load plugin modules. Each module is self-contained: it calls
-- `vim.pack.add` for its own plugin(s) and configures them immediately
--
-- Order matters only where setup() has a real runtime dependency:
--   which-key before mini/editor/notes (they call require('which-key').add()),
--   mason before lsp/debug, overseer before debug (enable_dap()).
--
-- Modules with a real load-order dependency go first (see comment above);
-- everything else under `lua/plugins/**` is discovered automatically, so
-- adding a new plugin module needs no edit here.
local priority = {
  "plugins.whichkey",
  "plugins.mini",
  "plugins.mason",
  "plugins.overseer",
}

local root = vim.fn.stdpath("config") .. "/lua/plugins"
local discovered = {}
for _, file in ipairs(vim.fn.globpath(root, "**/*.lua", false, true)) do
  table.insert(discovered, "plugins." .. file:gsub("^.*/lua/plugins/", ""):gsub("%.lua$", ""):gsub("/", "."))
end

local modules = vim.deepcopy(priority)
for _, mod in ipairs(require("utils.table").uniq(discovered)) do
  if not vim.tbl_contains(priority, mod) then
    table.insert(modules, mod)
  end
end

for _, mod in ipairs(modules) do
  local ok, err = pcall(require, mod)
  if not ok then
    vim.notify(("Failed to load %s:\n%s"):format(mod, err), vim.log.levels.ERROR)
  end
end
