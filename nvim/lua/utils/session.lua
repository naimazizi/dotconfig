local M = {}

-- Session name scoped to cwd only. Opening nvim from a different directory
-- (even a subdir of the same repo) looks up a different name by design.
function M.name()
  return (vim.fn.getcwd():gsub("[\\/:]", "%%"))
end

-- `mini.sessions.read()` throws if there's no detected session for `name`
-- (e.g. a project that's never been saved before). Only read if it exists.
function M.restore()
  local sessions = require("mini.sessions")
  local name = M.name()
  if not sessions.detected[name] then
    vim.notify("No saved session for this project", vim.log.levels.WARN)
    return
  end
  sessions.read(name)
end

return M
