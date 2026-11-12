local M = {}

local function locations(lines, node)
  local text, items, offset, row, line_start = table.concat(lines, "\n"), {}, 1, 1, 1
  -- shortcut: literal calls include comments; use a Jinja parser if evaluated references are needed.
  for start, args in text:gmatch("()%f[%w_]ref%s*%((.-)%)") do
    local _, name, rest = args:match("^%s*(['\"])(.-)%1%s*(.*)$")
    local package
    if rest then
      local _, second, tail = rest:match("^,%s*(['\"])(.-)%1%s*(.*)$")
      if second then
        package, name, rest = name, second, tail
      end
      local version = rest:match("^,%s*version%s*=%s*([%d%.]+)%s*,?%s*$")
        or rest:match("^,%s*v%s*=%s*([%d%.]+)%s*,?%s*$")
      local unversioned = rest:match("^,?%s*$")
      if
        name == node.name
        and (not package or package == node.package_name)
        and (
          (version and version == tostring(node.version))
          or (unversioned and (not node.version or node.version == node.latest_version))
        )
      then
        for newline in text:sub(offset, start - 1):gmatch("()\n") do
          row = row + 1
          line_start = offset + newline
        end
        offset = start
        table.insert(items, { line = row, col = start - line_start })
      end
    end
  end
  return items
end

local function load_manifest(root, file)
  -- Workers have separate Lua states; send only relevant nodes back to the UI thread.
  local ok, result, err = pcall(function()
    local handle, open_err = io.open(root .. "/target/manifest.json", "rb")
    if not handle then
      return nil, open_err
    end
    local content, read_err = handle:read("*a")
    local closed, close_err = handle:close()
    if not content then
      return nil, read_err
    end
    if not closed then
      return nil, close_err
    end
    local manifest = vim.json.decode(content)
    if type(manifest) ~= "table" or type(manifest.nodes) ~= "table" or type(manifest.child_map) ~= "table" then
      return nil, "Invalid dbt manifest: expected nodes and child_map"
    end
    local selected = { nodes = {}, child_map = {} }
    for id, node in pairs(manifest.nodes) do
      if node.original_file_path and vim.uv.fs_realpath(root .. "/" .. node.original_file_path) == file then
        selected.nodes[id] = node
        selected.child_map[id] = manifest.child_map[id]
        for _, child_id in ipairs(manifest.child_map[id] or {}) do
          selected.nodes[child_id] = manifest.nodes[child_id]
        end
      end
    end
    return vim.mpack.encode(selected)
  end)
  if ok then
    return result, err
  end
  return nil, tostring(result)
end

local function show_references(root, file, manifest)
  local found, seen, items = false, {}, {}
  for id, node in pairs(manifest.nodes) do
    if node.original_file_path and vim.fs.normalize(vim.fn.resolve(root .. "/" .. node.original_file_path)) == file then
      found = true
      for _, child_id in ipairs(manifest.child_map[id] or {}) do
        local child = manifest.nodes[child_id]
        if child and child.original_file_path and not seen[child_id] then
          seen[child_id] = true
          local path = root .. "/" .. child.original_file_path
          local buf = vim.fn.bufnr(path)
          local read_ok, lines = pcall(function()
            if buf ~= -1 and vim.api.nvim_buf_is_loaded(buf) then
              return vim.api.nvim_buf_get_lines(buf, 0, -1, false)
            end
            return vim.fn.readfile(path)
          end)
          local matches = {}
          if read_ok then
            matches = locations(lines, node)
          else
            vim.notify("Cannot read dbt reference " .. path .. ": " .. tostring(lines), vim.log.levels.WARN)
          end
          if #matches == 0 then
            table.insert(items, { id = child_id, path = child.original_file_path })
          else
            for _, location in ipairs(matches) do
              location.id, location.path = child_id, child.original_file_path
              table.insert(items, location)
            end
          end
        end
      end
    end
  end
  if not found then
    vim.notify("Current file is not in the dbt manifest. Run dbt parse to refresh it.", vim.log.levels.WARN)
    return
  end
  if #items == 0 then
    vim.notify("No direct dbt references in the manifest", vim.log.levels.INFO)
    return
  end
  table.sort(items, function(a, b)
    if a.id ~= b.id then
      return a.id < b.id
    end
    return a.line < b.line or (a.line == b.line and a.col < b.col)
  end)
  vim.ui.select(items, {
    prompt = "Direct dbt references",
    format_item = function(item)
      return item.id .. " — " .. item.path .. (item.line and ":" .. item.line or " (location unavailable)")
    end,
  }, function(item)
    if not item then
      return
    end
    local path = root .. "/" .. item.path
    if vim.fn.filereadable(path) ~= 1 then
      vim.notify("dbt reference file is missing: " .. path .. ". Run dbt parse to refresh.", vim.log.levels.ERROR)
      return
    end
    vim.cmd.edit(vim.fn.fnameescape(path))
    if item.line then
      vim.api.nvim_win_set_cursor(0, { item.line, item.col })
      vim.cmd("normal! zv")
    end
  end)
end

function M.references(root)
  local buf = vim.api.nvim_get_current_buf()
  local file = vim.fs.normalize(vim.fn.resolve(vim.api.nvim_buf_get_name(buf)))
  local work = vim.uv.new_work(
    load_manifest,
    vim.schedule_wrap(function(result, err)
      if not result then
        vim.notify("Cannot read dbt manifest: " .. tostring(err) .. ". Run dbt parse in " .. root, vim.log.levels.ERROR)
        return
      end
      if
        vim.api.nvim_get_current_buf() ~= buf
        or vim.fs.normalize(vim.fn.resolve(vim.api.nvim_buf_get_name(buf))) ~= file
      then
        return
      end
      show_references(root, file, vim.mpack.decode(result))
    end)
  )
  local queued, err = work:queue(root, file)
  if not queued then
    vim.notify("Cannot queue dbt manifest worker: " .. tostring(err), vim.log.levels.ERROR)
  end
end

function M.keymap(buf)
  if vim.g.vscode or not vim.tbl_contains({ "sql", "python", "csv" }, vim.bo[buf].filetype) then
    return
  end
  local root = vim.fs.root(buf, "dbt_project.yml")
  if root then
    vim.keymap.set("n", "gr", function()
      M.references(root)
    end, { buffer = buf, silent = true, desc = "dbt: Direct references" })
  end
end

return M
