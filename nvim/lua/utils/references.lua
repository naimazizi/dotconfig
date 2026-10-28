local M = {}

local function before(a, b)
  return a[1] < b[1] or (a[1] == b[1] and a[2] < b[2])
end

local function word_ranges(buf, cursor)
  local line = vim.api.nvim_buf_get_lines(buf, cursor[1] - 1, cursor[1], false)[1] or ""
  if vim.fn.matchstr(line:sub(cursor[2] + 1), [[^\k]]) == "" then
    return {}
  end

  -- shortcut: whole-word matches include unrelated symbols; use LSP for symbol identity.
  local word = vim.fn.escape(vim.fn.expand("<cword>"), [[\]])
  local pattern = vim.regex([[\C\V\<]] .. word .. [[\>]])
  local ranges = {}
  for row = 0, vim.api.nvim_buf_line_count(buf) - 1 do
    local offset = 0
    while true do
      local start, finish = pattern:match_line(buf, row, offset)
      if not start then
        break
      end
      start, finish = start + offset, finish + offset
      table.insert(ranges, { { row + 1, start }, { row + 1, finish } })
      offset = finish
    end
  end
  return ranges
end

function M.jump(forward)
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(win)
  local tick = vim.api.nvim_buf_get_changedtick(buf)
  local count = vim.v.count1

  local function jump_to(ranges)
    local positions = {}
    for _, range in ipairs(ranges) do
      local start, finish = range[1], range[2]
      if
        (forward and before(cursor, start)) or (not forward and before(start, cursor) and not before(cursor, finish))
      then
        table.insert(positions, start)
      end
    end
    table.sort(positions, before)
    local target = positions[forward and count or #positions - count + 1]
    if not target then
      vim.notify("No " .. (forward and "next" or "previous") .. " reference", vim.log.levels.INFO)
      return
    end
    vim.cmd("normal! m'")
    vim.api.nvim_win_set_cursor(win, target)
    vim.cmd("normal! zv")
  end

  local method = "textDocument/documentHighlight"
  local client = vim.lsp.get_clients({ bufnr = buf, method = method })[1]
  if not client then
    jump_to(word_ranges(buf, cursor))
    return
  end

  local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
  local sent = client:request(method, params, function(err, result)
    -- Ignore responses after the user moves, edits, or switches buffers/windows.
    if
      not vim.api.nvim_win_is_valid(win)
      or vim.api.nvim_get_current_win() ~= win
      or vim.api.nvim_win_get_buf(win) ~= buf
      or vim.api.nvim_buf_get_changedtick(buf) ~= tick
      or not vim.deep_equal(vim.api.nvim_win_get_cursor(win), cursor)
    then
      return
    end
    if err then
      vim.notify("LSP document highlights failed: " .. err.message, vim.log.levels.WARN)
    end
    if err or not result or #result == 0 then
      jump_to(word_ranges(buf, cursor))
      return
    end

    local function position(pos)
      local line = vim.api.nvim_buf_get_lines(buf, pos.line, pos.line + 1, false)[1] or ""
      return { pos.line + 1, vim.str_byteindex(line, client.offset_encoding, pos.character, false) }
    end
    local ranges = {}
    for _, highlight in ipairs(result) do
      table.insert(ranges, { position(highlight.range.start), position(highlight.range["end"]) })
    end
    jump_to(ranges)
  end, buf)
  if not sent then
    vim.notify("Could not request LSP document highlights", vim.log.levels.WARN)
    jump_to(word_ranges(buf, cursor))
  end
end

function M.setup()
  local function map(buf)
    vim.keymap.set("n", "]]", function()
      M.jump(true)
    end, { buffer = buf, desc = "Next reference" })
    vim.keymap.set("n", "[[", function()
      M.jump(false)
    end, { buffer = buf, desc = "Previous reference" })
  end
  map()
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("reference_navigation", { clear = true }),
    callback = function(ev)
      -- Apply after ftplugins without overwriting special-buffer navigation.
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(ev.buf) then
          return
        end
        local buftype = vim.bo[ev.buf].buftype
        if buftype == "" or (vim.g.vscode and buftype == "acwrite") then
          map(ev.buf)
        end
      end)
    end,
  })
end

return M
