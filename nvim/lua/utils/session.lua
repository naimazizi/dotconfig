local M = {}

local function restore_highlighting()
  if vim.g.vscode then
    return
  end
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if
      vim.api.nvim_buf_is_loaded(buf)
      and vim.bo[buf].buftype == ""
      and vim.bo[buf].filetype ~= ""
      and vim.treesitter.get_parser(buf, nil, { error = false })
    then
      local ok, err = pcall(vim.treesitter.start, buf)
      if not ok then
        vim.notify(
          "Cannot restore Tree-sitter highlighting for " .. vim.api.nvim_buf_get_name(buf) .. ": " .. tostring(err),
          vim.log.levels.WARN
        )
      end
    end
  end
end

local function save_breakpoints()
  local saved = {}
  if package.loaded["dap"] then
    for buf, breakpoints in pairs(require("dap.breakpoints").get()) do
      local path = vim.api.nvim_buf_get_name(buf)
      if path ~= "" and vim.bo[buf].buftype == "" then
        saved[path] = {}
        for _, bp in ipairs(breakpoints) do
          table.insert(saved[path], {
            line = bp.line,
            condition = bp.condition,
            log_message = bp.logMessage,
            hit_condition = bp.hitCondition,
          })
        end
      end
    end
  end
  -- Session globals must start uppercase and contain lowercase letters.
  vim.g.SessionBreakpoints = vim.json.encode(saved)
end

local function restore_breakpoints()
  if not package.loaded["dap"] and not vim.g.SessionBreakpoints then
    return
  end

  local breakpoints = require("dap.breakpoints")
  local saved = vim.json.decode(vim.g.SessionBreakpoints or "{}")
  breakpoints.clear()
  for path, entries in pairs(saved) do
    if vim.fn.filereadable(path) == 1 then
      local buf = vim.fn.bufadd(path)
      vim.fn.bufload(buf)
      for _, bp in ipairs(entries) do
        breakpoints.set(bp, buf, bp.line)
      end
    else
      vim.notify("Session breakpoint file is unavailable: " .. path, vim.log.levels.WARN)
    end
  end
end

local function restore_avante(tab)
  local placeholders, source = {}, nil
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == "nofile" and vim.bo[buf].filetype:match("^Avante") then
      table.insert(placeholders, win)
    elseif vim.bo[buf].buftype == "" and vim.fn.win_gettype(win) == "" then
      if not source or vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(source)) == "" then
        source = win
      end
    end
  end

  if #placeholders == 0 then
    return
  end
  if not source then
    vim.notify("Cannot restore Avante: the saved tab has no source window", vim.log.levels.WARN)
    return
  end

  -- Rebuild Avante's UI instead of keeping disconnected session windows.
  for _, win in ipairs(placeholders) do
    vim.api.nvim_win_close(win, true)
  end
  vim.api.nvim_win_call(source, function()
    require("avante").open_sidebar({})
  end)
end

M.hooks = {
  pre = {
    write = function()
      save_breakpoints()
      if package.loaded["dap-view"] then
        require("dap-view.vim-sessions").save_state()
      end
    end,
    read = function()
      vim.g.SessionBreakpoints = nil
      vim.g.DapviewSection = nil
      vim.g.DapviewExprCount = nil
      vim.g.DapviewWatches = nil
    end,
  },
  post = {
    write = function()
      if package.loaded["nvim-tree"] then
        -- Save synchronously after mini.sessions updates v:this_session, including on exit.
        require("nvim-tree.session").save()
      end
    end,
    read = function()
      restore_breakpoints()
      if package.loaded["dap-view"] then
        require("dap-view.vim-sessions").restore_state()
      end
      if package.loaded["nvim-tree"] then
        -- NvimTree's native SessionLoadPost handler is one-shot; also support later reads.
        require("nvim-tree.session").restore()
      end
      vim.schedule(function()
        -- Restored buffers may already have fired FileType before Tree-sitter setup.
        restore_highlighting()
        for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
          restore_avante(tab)
        end
      end)
    end,
  },
}

-- Each working directory, including subdirectories, has its own session.
function M.name()
  return (vim.fn.getcwd():gsub("[\\/:]", "%%"))
end

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
