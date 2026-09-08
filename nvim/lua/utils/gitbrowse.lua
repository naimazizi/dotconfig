-- Open the current file/line (or commit under cursor) in the browser.
-- Ported and trimmed from snacks.nvim's gitbrowse (github.com/folke/snacks.nvim).
local M = {}

-- stylua: ignore
local remote_patterns = {
  { "^(https?://.*)%.git$"        , "%1" },
  { "^git@(.+):(.+)%.git$"        , "https://%1/%2" },
  { "^git@(.+):(.+)$"             , "https://%1/%2" },
  { "^git@(.+)/(.+)$"             , "https://%1/%2" },
  { "^ssh://git@(.*)$"            , "https://%1" },
  { "^ssh://([^:/]+)(:%d+)/(.*)$" , "https://%1/%3" },
  { "^ssh://([^/]+)/(.*)$"        , "https://%1/%2" },
  { "^https://%w*@(.*)"           , "https://%1" },
  { "^git@(.*)"                   , "https://%1" },
  { ":%d+"                        , "" },
  { "%.git$"                      , "" },
}

---@type table<string, table<string, string?>>
local url_patterns = {
  ["github%.com"] = {
    branch = "/tree/{branch}",
    file = "/blob/{branch}/{file}#L{line_start}-L{line_end}",
    permalink = "/blob/{commit}/{file}#L{line_start}-L{line_end}",
    commit = "/commit/{commit}",
  },
  ["gitlab%.com"] = {
    branch = "/-/tree/{branch}",
    file = "/-/blob/{branch}/{file}#L{line_start}-{line_end}",
    permalink = "/-/blob/{commit}/{file}#L{line_start}-{line_end}",
    commit = "/-/commit/{commit}",
  },
  ["bitbucket%.org"] = {
    branch = "/src/{branch}",
    file = "/src/{branch}/{file}#lines-{line_start}-L{line_end}",
    permalink = "/src/{commit}/{file}#lines-{line_start}-L{line_end}",
    commit = "/commits/{commit}",
  },
  ["git%.sr%.ht"] = {
    branch = "/tree/{branch}",
    file = "/tree/{branch}/item/{file}",
    permalink = "/tree/{commit}/item/{file}#L{line_start}",
    commit = "/commit/{commit}",
  },
}

-- Run a git command without blocking the event loop; must be called inside a vim.async task.
---@async
local function system(cmd, err)
  -- vim.system's on_exit fires in a fast-loop context; schedule_wrap hops back
  -- to the main loop so the resumed coroutine can safely call vim.fn/vim.api.
  local result = vim.async.await(function(done)
    vim.system(cmd, { text = true }, vim.schedule_wrap(done))
  end)
  if result.code ~= 0 then
    vim.notify(err .. "\n" .. vim.trim(result.stderr or ""), vim.log.levels.ERROR, { title = "Git Browse" })
    return nil
  end
  return vim.split(vim.trim(result.stdout or ""), "\n")
end

local function get_repo(remote)
  local ret = remote
  for _, pattern in ipairs(remote_patterns) do
    ret = ret:gsub(pattern[1], pattern[2])
  end
  return ret:find("https://") == 1 and ret or ("https://%s"):format(ret)
end

local function get_url(repo, what, fields)
  for remote, patterns in pairs(url_patterns) do
    if repo:find(remote) and patterns[what] then
      return repo .. patterns[what]:gsub("(%b{})", function(key)
        return fields[key:sub(2, -2)] or key
      end)
    end
  end
  return repo
end

---@async
local function is_commit_hash(hash, cwd)
  return hash:match("^%x+$") ~= nil and #hash >= 7 and system({ "git", "-C", cwd, "rev-parse", "--verify", hash }, "") ~= nil
end

---@param opts? { what?: "file"|"branch"|"commit"|"permalink"|"repo" }
function M.open(opts)
  -- raise_on_error: this is a fire-and-forget task, so surface failures
  -- instead of letting them vanish silently.
  vim.async.run(function()
    M._open(opts)
  end):raise_on_error()
end

---@async
---@param opts? { what?: "file"|"branch"|"commit"|"permalink"|"repo" }
function M._open(opts)
  local what = opts and opts.what or "file"
  local bufname = vim.api.nvim_buf_get_name(0)
  ---@type string?
  local file = bufname ~= "" and (vim.uv.fs_stat(bufname) or {}).type == "file" and vim.fs.normalize(bufname) or nil
  local cwd = file and vim.fn.fnamemodify(file, ":h") or vim.fn.getcwd()

  local branch = system({ "git", "-C", cwd, "rev-parse", "--abbrev-ref", "HEAD" }, "Failed to get current branch")
  local fields = {
    branch = branch and branch[1],
    file = file and (system({ "git", "-C", cwd, "ls-files", "--full-name", file }, "Failed to get git file path") or {})[1],
  }

  if what == "permalink" then
    local commit = system({ "git", "-C", cwd, "log", "-n", "1", "--pretty=format:%H", "--", fields.file or "" }, "Failed to get latest commit")
    fields.commit = commit and commit[1]
  else
    local word = vim.fn.expand("<cword>") --[[@as string]]
    fields.commit = is_commit_hash(word, cwd) and word or nil
  end

  if vim.fn.mode():find("[vV]") then
    vim.fn.feedkeys(":", "nx")
    local line_start, line_end = vim.api.nvim_buf_get_mark(0, "<")[1], vim.api.nvim_buf_get_mark(0, ">")[1]
    vim.fn.feedkeys("gv", "nx")
    fields.line_start, fields.line_end = math.min(line_start, line_end), math.max(line_start, line_end)
  else
    fields.line_start = vim.fn.line(".")
    fields.line_end = fields.line_start
  end

  if not fields.commit and what == "permalink" then
    what = "file"
  end
  if not fields.file and not fields.commit then
    what = fields.branch and "branch" or "repo"
  end

  local remotes = {}
  for _, line in ipairs(system({ "git", "-C", cwd, "remote", "-v" }, "Failed to get git remotes") or {}) do
    local name, remote = line:match("(%S+)%s+(%S+)%s+%(fetch%)")
    if name and remote then
      table.insert(remotes, { name = name, url = get_url(get_repo(remote), what, fields) })
    end
  end

  if #remotes == 0 then
    return vim.notify("No git remotes found", vim.log.levels.ERROR, { title = "Git Browse" })
  end

  local function open(remote)
    if remote then
      vim.notify(("Opening [%s](%s)"):format(remote.name, remote.url), vim.log.levels.INFO, { title = "Git Browse" })
      vim.ui.open(remote.url)
    end
  end

  if #remotes == 1 then
    return open(remotes[1])
  end
  vim.ui.select(remotes, {
    prompt = "Select remote to browse",
    format_item = function(item)
      return item.name .. "  " .. item.url
    end,
  }, open)
end

return M
