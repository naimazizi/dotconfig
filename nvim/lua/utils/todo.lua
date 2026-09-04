local M = {}

local todo_words = { "TODO", "FIX", "FIXME", "HACK", "NOTE" }

-- Collect {line (1-indexed), col (0-indexed)} for every TODO-like keyword
-- that lives inside a treesitter `@comment` capture. Falls back to nothing
-- (no jump) if the buffer has no parser/highlighter, rather than ever
-- searching non-comment text.
local function todo_positions_in_comments(bufnr)
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
  if not ok or not parser then
    return {}
  end
  local query_ok, query = pcall(vim.treesitter.query.get, parser:lang(), "highlights")
  if not query_ok or not query then
    return {}
  end

  local positions = {}
  for _, tree in ipairs(parser:parse()) do
    for id, node in query:iter_captures(tree:root(), bufnr, 0, -1) do
      if query.captures[id] == "comment" then
        local srow, scol, erow, ecol = node:range()
        for lnum = srow, erow do
          local line = vim.api.nvim_buf_get_lines(bufnr, lnum, lnum + 1, false)[1] or ""
          local from = lnum == srow and scol + 1 or 1
          local to = lnum == erow and ecol or #line
          local segment = line:sub(from, to)
          for _, word in ipairs(todo_words) do
            local init = 1
            while true do
              local s, e = segment:find("%f[%w]" .. word .. "%f[%W]", init)
              if not s then
                break
              end
              table.insert(positions, { lnum + 1, from - 1 + s - 1 })
              init = e + 1
            end
          end
        end
      end
    end
  end
  table.sort(positions, function(a, b)
    return a[1] < b[1] or (a[1] == b[1] and a[2] < b[2])
  end)
  return positions
end

function M.jump(forward)
  return function()
    local positions = todo_positions_in_comments(0)
    if #positions == 0 then
      return
    end
    local cur = vim.api.nvim_win_get_cursor(0)
    if forward then
      for _, pos in ipairs(positions) do
        if pos[1] > cur[1] or (pos[1] == cur[1] and pos[2] > cur[2]) then
          return vim.api.nvim_win_set_cursor(0, pos)
        end
      end
      vim.api.nvim_win_set_cursor(0, positions[1]) -- wrap to first
    else
      for i = #positions, 1, -1 do
        local pos = positions[i]
        if pos[1] < cur[1] or (pos[1] == cur[1] and pos[2] < cur[2]) then
          return vim.api.nvim_win_set_cursor(0, pos)
        end
      end
      vim.api.nvim_win_set_cursor(0, positions[#positions]) -- wrap to last
    end
  end
end

return M
