local M = {}

-- LSP picker helper: jump directly if single result, open picker if multiple
---@param scope string LSP method scope
function M.pick_lsp(scope)
  local direct_scopes = { definition = true, type_definition = true, implementation = true }
  if direct_scopes[scope] then
    return function()
      local method = "textDocument/" .. scope
      local clients = vim.lsp.get_clients({ bufnr = 0, method = method })
      if #clients == 0 then
        vim.notify("No LSP client supports " .. scope, vim.log.levels.WARN)
        return
      end
      local client = clients[1]
      local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
      client:request(method, params, function(err, result)
        if err then
          vim.notify(err.message, vim.log.levels.WARN)
          return
        end
        if not result or (vim.islist(result) and #result == 0) then
          vim.notify("No " .. scope .. " found", vim.log.levels.INFO)
          return
        end
        local items = vim.islist(result) and result or { result }
        if #items == 1 then
          vim.lsp.util.show_document(items[1], client.offset_encoding, { focus = true })
        else
          require("mini.extra").pickers.lsp({ scope = scope })
        end
      end)
    end
  end

  if scope == "references" then
    return function()
      local cursor_file = vim.api.nvim_buf_get_name(0)
      local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
      local orig_refs = vim.lsp.buf.references
      vim.lsp.buf.references = function(context, opts)
        local orig_on_list = opts and opts.on_list
        if orig_on_list then
          opts.on_list = function(data)
            local filtered = {}
            for _, item in ipairs(data.items) do
              if not (item.filename == cursor_file and item.lnum == cursor_line) then
                table.insert(filtered, item)
              end
            end
            data.items = filtered
            orig_on_list(data)
          end
        end
        vim.lsp.buf.references = orig_refs
        return orig_refs(context, opts)
      end
      require("mini.extra").pickers.lsp({ scope = "references" })
    end
  end

  return function()
    require("mini.extra").pickers.lsp({ scope = scope })
  end
end

-- Set LSP keymaps on a buffer
function M.lsp_keymaps(bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end

  map("n", "gd", M.pick_lsp("definition"), "Goto definition")
  map("n", "gr", M.pick_lsp("references"), "References")
  map("n", "gi", M.pick_lsp("implementation"), "Goto implementation")
  map("n", "gy", M.pick_lsp("type_definition"), "Goto type definition")

  map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
  map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")

  map("n", "<leader>ss", M.pick_lsp("document_symbol"), "Symbols (document)")
  map("n", "<leader>sS", M.pick_lsp("workspace_symbol"), "Symbols (workspace)")

  map("n", "<leader>ci", M.pick_lsp("incoming_calls"), "Incoming calls")
  map("n", "<leader>co", M.pick_lsp("outgoing_calls"), "Outgoing calls")

  map("n", "<leader>cc", vim.lsp.codelens.run, "CodeLens")
end

-- Abbreviate deep paths: keep last 2 components, shorten rest to first letter
function M.shorten_path(path)
  local sep = "/"
  local parts = vim.split(path, sep)
  if #parts <= 2 then
    return path
  end
  for i = 1, #parts - 2 do
    parts[i] = parts[i]:sub(1, 1)
  end
  return table.concat(parts, sep)
end

-- Custom show function for mini.pick: abbreviates paths
function M.short_show(buf_id, items, query)
  local pick = require("mini.pick")
  local short_items = {}
  for i, item in ipairs(items) do
    local s = type(item) == "string" and item or (type(item) == "table" and item.text or vim.inspect(item))
    local parts = vim.split(s, "\0")
    if #parts >= 1 then
      parts[1] = M.shorten_path(parts[1])
      s = table.concat(parts, "\0")
    end
    short_items[i] = s
  end
  pick.default_show(buf_id, short_items, query, { show_icons = true })
end

-- Send current matches (or marked items) to quickfix list
function M.send_to_qflist()
  local matches = MiniPick.get_picker_matches() or {}
  local target = (matches.marked and #matches.marked > 0) and matches.marked or matches.all or {}
  local qf_items = {}
  for _, item in ipairs(target) do
    if type(item) == "table" then
      table.insert(qf_items, {
        filename = item.path or item.filename or "",
        lnum = item.lnum or 1,
        col = item.col or 1,
        text = item.text or "",
      })
    elseif type(item) == "string" then
      local parts = vim.split(item, "\0")
      if #parts >= 3 then
        table.insert(qf_items, {
          filename = parts[1],
          lnum = tonumber(parts[2]) or 1,
          col = tonumber(parts[3]) or 1,
          text = parts[4] or "",
        })
      elseif #parts == 2 then
        table.insert(qf_items, {
          filename = parts[1],
          lnum = tonumber(parts[2]) or 1,
          col = 1,
          text = "",
        })
      else
        local file, lnum, col, text = item:match("^(.-):(%-?%d+):(%-?%d+):(.*)$")
        if file then
          table.insert(qf_items, {
            filename = file,
            lnum = tonumber(lnum) or 1,
            col = tonumber(col) or 1,
            text = text or "",
          })
        else
          table.insert(qf_items, { text = item })
        end
      end
    end
  end
  MiniPick.stop()
  if #qf_items > 0 then
    vim.fn.setqflist(qf_items)
    vim.cmd("copen")
  end
end

-- Wrap builtin.grep to inject --trim into rg commands
function M.setup_grep_trim(pick)
  local orig_grep = pick.builtin.grep
  pick.builtin.grep = function(local_opts, opts)
    local_opts = local_opts or {}
    local tool = local_opts.tool or "rg"
    if tool ~= "rg" then
      return orig_grep(local_opts, opts)
    end
    local pattern = type(local_opts.pattern) == "string" and local_opts.pattern or vim.fn.input("Grep pattern: ")
    if not pattern or pattern == "" then
      return
    end
    local globs = local_opts.globs or {}
    local cmd = {
      "rg",
      "--column",
      "--line-number",
      "--no-heading",
      "--field-match-separator",
      "\\x00",
      "--color=never",
      "--trim",
    }
    for _, g in ipairs(globs) do
      table.insert(cmd, "--glob")
      table.insert(cmd, g)
    end
    local case = vim.o.ignorecase and (vim.o.smartcase and "smart-case" or "ignore-case") or "case-sensitive"
    vim.list_extend(cmd, { "--" .. case, "--", pattern })
    local show = pick.config.source.show
    local name_suffix = #globs == 0 and "" or (" | " .. table.concat(globs, ", "))
    opts = vim.tbl_deep_extend("force", {
      source = { name = string.format("Grep (rg%s)", name_suffix), show = show },
    }, opts or {})
    return pick.builtin.cli({ command = cmd }, opts)
  end

  local orig_grep_live = pick.builtin.grep_live
  pick.builtin.grep_live = function(local_opts, opts)
    local_opts = local_opts or {}
    local tool = local_opts.tool or "rg"
    if tool ~= "rg" then
      return orig_grep_live(local_opts, opts)
    end
    local globs = local_opts.globs or {}
    local show = pick.config.source.show
    local name_suffix = #globs == 0 and "" or (" | " .. table.concat(globs, ", "))
    opts = vim.tbl_deep_extend("force", {
      source = { name = string.format("Grep live (rg%s)", name_suffix), show = show },
    }, opts or {})

    local cwd = opts.source and opts.source.cwd and vim.fn.fnamemodify(opts.source.cwd, ":p") or vim.fn.getcwd()
    local set_items_opts = { do_match = false, querytick = 0 }
    local spawn_opts = { cwd = cwd }
    local sys = { kill = function() end }
    local querytick = 0

    local match = function(_, _, query)
      sys:kill()
      querytick = querytick + 1
      if #query == 0 then
        sys = { kill = function() end }
        return pick.set_picker_items({}, set_items_opts)
      end

      set_items_opts.querytick = querytick
      local cmd = {
        "rg",
        "--column",
        "--line-number",
        "--no-heading",
        "--field-match-separator",
        "\\x00",
        "--color=never",
        "--trim",
      }
      for _, g in ipairs(globs) do
        table.insert(cmd, "--glob")
        table.insert(cmd, g)
      end
      local case = vim.o.ignorecase and (vim.o.smartcase and "smart-case" or "ignore-case") or "case-sensitive"
      vim.list_extend(cmd, { "--" .. case, "--", table.concat(query) })
      sys = pick.set_picker_items_from_cli(cmd, { set_items_opts = set_items_opts, spawn_opts = spawn_opts })
    end

    local add_glob = function()
      local ok, glob = pcall(vim.fn.input, "Glob pattern: ")
      if ok then
        table.insert(globs, glob)
      end
      name_suffix = #globs == 0 and "" or (" | " .. table.concat(globs, ", "))
      pick.set_picker_opts({ source = { name = string.format("Grep live (rg%s)", name_suffix) } })
      pick.set_picker_query(pick.get_picker_query())
    end

    opts.source = vim.tbl_deep_extend("force", opts.source or {}, {
      items = {},
      match = match,
    })
    opts.mappings = vim.tbl_deep_extend("force", opts.mappings or {}, {
      add_glob = { char = "<C-o>", func = add_glob },
    })
    return pick.start(opts)
  end
end

-- Setup preview window that appears alongside mini.pick
function M.setup_preview(pick, pick_total_width, pick_split)
  local preview_win = nil
  local preview_buf = nil
  local preview_timer = nil
  local preview_last_item = nil

  local function close_preview()
    if preview_win and vim.api.nvim_win_is_valid(preview_win) then
      vim.api.nvim_win_close(preview_win, true)
    end
    preview_win = nil
    if preview_buf and vim.api.nvim_buf_is_valid(preview_buf) then
      vim.api.nvim_buf_delete(preview_buf, { force = true })
    end
    preview_buf = nil
  end

  local function open_preview()
    close_preview()
    preview_buf = vim.api.nvim_create_buf(false, true)
    vim.bo[preview_buf].buftype = "nofile"
    vim.bo[preview_buf].bufhidden = "hide"

    local pw = vim.api.nvim_get_current_win()
    if not vim.api.nvim_win_is_valid(pw) then
      return
    end
    local pc = vim.api.nvim_win_get_config(pw)
    if not pc.relative or pc.relative == "" then
      return
    end

    local total_w = math.floor(pick_total_width * vim.o.columns)
    local results_w = math.floor(pick_split * total_w)
    local preview_w = total_w - results_w - 2
    local col = vim.o.columns - results_w - 2

    pcall(function()
      preview_win = vim.api.nvim_open_win(preview_buf, false, {
        relative = "editor",
        focusable = false,
        style = "minimal",
        border = pc.border,
        noautocmd = pc.noautocmd,
        anchor = pc.anchor,
        zindex = pc.zindex and (pc.zindex - 1),
        height = pc.height,
        row = pc.row,
        col = col,
        width = preview_w,
      })
    end)

    if preview_win and vim.api.nvim_win_is_valid(preview_win) then
      pcall(function()
        vim.api.nvim_set_hl(0, "MiniPickPreviewNormal", { link = "MiniPickNormal" })
        vim.api.nvim_set_hl(0, "MiniPickPreviewBorder", { link = "MiniPickBorder" })
        vim.api.nvim_win_set_config(
          preview_win,
          { winhighlight = "Normal:MiniPickPreviewNormal,FloatBorder:MiniPickPreviewBorder" }
        )
      end)
    end
  end

  local preview_group = vim.api.nvim_create_augroup("MiniPickPreview", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    group = preview_group,
    pattern = "MiniPickStart",
    callback = function()
      open_preview()
      preview_last_item = nil
      preview_timer = vim.uv.new_timer()
      preview_timer:start(100, 100, function()
        vim.schedule(function()
          pcall(function()
            if not MiniPick or not MiniPick.get_picker_matches then
              return
            end
            local ok, matches = pcall(MiniPick.get_picker_matches)
            if not ok or not matches or not matches.current then
              return
            end
            if matches.current ~= preview_last_item then
              preview_last_item = matches.current
              local item = matches.current
              local filepath = nil
              if type(item) == "table" then
                filepath = item.path or item.filename
              elseif type(item) == "string" then
                local parts = vim.split(item, "\0")
                filepath = parts[1]
                if not filepath or filepath == "" then
                  filepath = item:match("^(.-):%d+:")
                end
              end
              local is_text = true
              if filepath and vim.fn.filereadable(filepath) == 1 then
                local mime = vim.fn.system({ "file", "--mime-type", "-b", filepath }):gsub("%s+$", "")
                is_text = vim.startswith(mime, "text/")
                  or mime == "application/json"
                  or mime == "application/xml"
                  or mime == "application/javascript"
                if is_text then
                  is_text = vim.fn.getfsize(filepath) > 0
                end
              end
              if is_text and preview_buf and vim.api.nvim_buf_is_valid(preview_buf) then
                pcall(function()
                  MiniPick.default_preview(preview_buf, matches.current)
                  vim.defer_fn(function()
                    pcall(vim.cmd, "redraw")
                  end, MiniPick.config.delay.async)
                end)
              end
            end
          end)
        end)
      end)
    end,
  })
  vim.api.nvim_create_autocmd("User", {
    group = preview_group,
    pattern = "MiniPickStop",
    callback = function()
      if preview_timer then
        preview_timer:stop()
        preview_timer:close()
        preview_timer = nil
      end
      preview_last_item = nil
      close_preview()
    end,
  })
end

return M
