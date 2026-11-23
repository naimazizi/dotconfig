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

local function close_stale_picker_layouts()
  local active = {}
  if package.loaded["snacks.picker"] then
    for _, picker in ipairs(Snacks.picker.get({ tab = false })) do
      if picker.layout and picker.layout.root and picker.layout.root.win then
        active[picker.layout.root.win] = true
      end
    end
  end

  for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].filetype == "snacks_layout_box" and not active[win] then
        local normal_windows = 0
        for _, other in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
          if vim.api.nvim_win_get_config(other).relative == "" then
            normal_windows = normal_windows + 1
          end
        end
        if normal_windows > 1 then
          vim.api.nvim_win_close(win, false)
        else
          vim.api.nvim_win_set_buf(win, vim.api.nvim_create_buf(true, false))
        end
      end
    end
  end
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
    read = function()
      close_stale_picker_layouts()
      restore_breakpoints()
      if package.loaded["dap-view"] then
        require("dap-view.vim-sessions").restore_state()
      end
      vim.schedule(function()
        -- Restored buffers may already have fired FileType before Tree-sitter setup.
        restore_highlighting()
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
