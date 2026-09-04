local M = {}

-- Session name scoped to cwd + git branch, mirroring persistence.nvim's
-- `branch = true` behavior (mini.sessions has no such concept built in).
function M.name()
  local raw_cwd = vim.fn.getcwd()
  local name = raw_cwd:gsub("[\\/:]", "%%")
  if vim.fn.executable("git") ~= 1 then
    return name
  end

  local ok, proc = pcall(vim.system, { "git", "branch", "--show-current" }, { cwd = raw_cwd, text = true })
  local result = ok and proc:wait() or nil
  local branch = (result and result.code == 0) and vim.trim(result.stdout or "") or ""
  return branch ~= "" and (name .. "%" .. branch) or name
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
