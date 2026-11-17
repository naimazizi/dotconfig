if vim.g.vscode then
  return
end

Config.on_packchanged("cursortab.nvim", { "install", "update" }, function(data)
  vim.async.run(function()
    local result = vim.async.await(3, vim.system, { "go", "build" }, { cwd = data.path .. "/server" })
    if result.code ~= 0 then
      local output = (result.stderr ~= "" and result.stderr) or result.stdout or "No output from build command."
      vim.notify(("Build failed for cursortab.nvim:\n%s"):format(output), vim.log.levels.ERROR)
    else
      vim.notify("Built cursortab.nvim server successfully", vim.log.levels.INFO)
    end
  end)
end, "Build cursortab.nvim server")

vim.pack.add({
  Config.gh("carderne/pi-nvim"),
  Config.gh("ingur/floatty.nvim"),
  Config.gh("cursortab/cursortab.nvim"),
})

Config.later(function()
  require("pi-nvim").setup({ set_default_keymaps = false })

  local pi = require("floatty").setup({
    cmd = { "pi-bolt", "--continue" },
    id = 1,
    window = {
      width = 0.30,
      height = function()
        return vim.o.lines - 10
      end,
      col = function()
        return vim.o.columns - math.floor(vim.o.columns * 0.30) - 4 -- Border plus two-column gap.
      end,
      v_align = "center",
      border = "single",
    },
    on_open = function(_, buf)
      vim.bo[buf].bufhidden = "hide"
      vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, desc = "Hide Pi-Bolt sidebar" })
      vim.keymap.set("t", "<leader>ac", "<C-\\><C-n><cmd>close<cr>", {
        buffer = buf,
        desc = "Hide Pi-Bolt sidebar",
      })
      -- Floatty reuses exited terminals unless their buffers are wiped.
      vim.api.nvim_create_autocmd("TermClose", {
        buffer = buf,
        once = true,
        callback = function()
          vim.schedule(function()
            local win = vim.fn.bufwinid(buf)
            if win ~= -1 then
              vim.api.nvim_win_close(win, true)
            end
            if vim.api.nvim_buf_is_valid(buf) then
              vim.api.nvim_buf_delete(buf, { force = true })
            end
          end)
        end,
      })
    end,
  })

  -- Target only Floatty's Pi process, never another session in the same directory.
  ---@type { get_socket_path: fun(): string? }
  local pi_bridge = require("pi-nvim")
  pi_bridge.get_socket_path = function()
    local term = pi.terms[1]
    if not term or not vim.api.nvim_buf_is_valid(term.buf) then
      return nil
    end
    local pid = vim.b[term.buf].terminal_job_pid
    if not pid then
      return nil
    end
    return vim.fn.glob("/tmp/pi-nvim-sockets/*-" .. pid .. ".sock", false, true)[1]
  end

  ---@type integer|nil
  local source_win
  local function toggle_pi_focus()
    local term = pi.terms[1]
    if term and term.win and vim.api.nvim_win_is_valid(term.win) then
      if vim.api.nvim_get_current_win() == term.win then
        if source_win and vim.api.nvim_win_is_valid(source_win) then
          vim.api.nvim_set_current_win(source_win)
          vim.cmd.stopinsert()
        end
      else
        source_win = vim.api.nvim_get_current_win()
        vim.api.nvim_set_current_win(term.win)
        vim.cmd.startinsert()
      end
    else
      source_win = vim.api.nvim_get_current_win()
      pi.toggle()
    end
  end

  local map = vim.keymap.set
  map({ "n", "i", "t" }, "<C-;>", toggle_pi_focus, { desc = "Focus Pi-Bolt / source buffer" })
  map("n", "<leader>ac", function()
    source_win = vim.api.nvim_get_current_win()
    pi.toggle()
  end, { desc = "Toggle Pi-Bolt sidebar" })
  map("n", "<leader>aa", "<cmd>PiSendFile<cr>", { desc = "Send buffer to Pi" })
  map("n", "<leader>aA", "<cmd>PiSend<cr>", { desc = "Send prompt to Pi" })
  map("x", "<leader>aa", ":PiSendSelection<cr>", { silent = true, desc = "Send selection to Pi" })
  map("n", "<leader>ad", function()
    local buf = vim.api.nvim_get_current_buf()
    local diagnostics = vim.diagnostic.get(buf, {
      severity = { min = vim.diagnostic.severity.WARN, max = vim.diagnostic.severity.ERROR },
    })
    if #diagnostics == 0 then
      vim.notify("No errors or warnings in current file", vim.log.levels.INFO)
      return
    end
    local path = vim.api.nvim_buf_get_name(buf)
    if path == "" or vim.bo[buf].buftype ~= "" then
      vim.notify("Pi diagnostics require a named file buffer", vim.log.levels.WARN)
      return
    end
    local lines = { "Explain and fix these diagnostics from the current file only:" }
    for _, diagnostic in ipairs(diagnostics) do
      lines[#lines + 1] = ("%s:%d:%d [%s] %s"):format(
        path,
        diagnostic.lnum + 1,
        diagnostic.col + 1,
        vim.diagnostic.severity[diagnostic.severity],
        diagnostic.message
      )
    end
    require("pi-nvim").prompt(table.concat(lines, "\n"))
  end, { desc = "Send current file diagnostics to Pi" })
  map("n", "<leader>aD", function()
    local diagnostics = vim.diagnostic.get()
    if #diagnostics == 0 then
      vim.notify("No diagnostics available", vim.log.levels.INFO)
      return
    end
    local lines = { "Explain and fix these diagnostics across files:" }
    for _, diagnostic in ipairs(diagnostics) do
      local path = vim.api.nvim_buf_get_name(diagnostic.bufnr)
      if path == "" then
        path = ("[unnamed buffer %d]"):format(diagnostic.bufnr)
      end
      lines[#lines + 1] = ("%s:%d:%d [%s] %s"):format(
        path,
        diagnostic.lnum + 1,
        diagnostic.col + 1,
        vim.diagnostic.severity[diagnostic.severity],
        diagnostic.message
      )
    end
    require("pi-nvim").prompt(table.concat(lines, "\n"))
  end, { desc = "Send all diagnostics to Pi" })
  map("n", "<leader>aq", function()
    local items = vim.fn.getqflist()
    if #items == 0 then
      vim.notify("Quickfix list is empty", vim.log.levels.INFO)
      return
    end
    local lines = { "Explain and fix the issues in this quickfix list:" }
    for _, item in ipairs(items) do
      local path = item.bufnr > 0 and vim.api.nvim_buf_get_name(item.bufnr) or "[no file]"
      lines[#lines + 1] = ("%s:%d:%d %s%s"):format(
        path,
        item.lnum,
        item.col,
        item.type ~= "" and ("[" .. item.type .. "] ") or "",
        item.text
      )
    end
    require("pi-nvim").prompt(table.concat(lines, "\n"))
  end, { desc = "Send quickfix list to Pi" })
end)

Config.disabled(function()
  vim.pack.add({ Config.gh("nickjvandyke/opencode.nvim") })

  local map = vim.keymap.set
  map({ "n", "x" }, "<leader>aa", function()
    require("opencode").ask("@this: ")
  end, { desc = "Ask OpenCode…" })
  map({ "n", "x" }, "<leader>as", function()
    require("opencode").select()
  end, { desc = "Select OpenCode…" })
  map("x", "<leader>aw", function()
    return require("opencode").operator("@this ")
  end, { expr = true, desc = "Append range to OpenCode" })
  map("n", "<leader>aw", function()
    return require("opencode").operator("@this ") .. "_"
  end, { expr = true, desc = "Append line to OpenCode" })
  map("n", "<S-C-u>", function()
    require("opencode").command("session.half.page.up")
  end, { desc = "Scroll OpenCode up" })
  map("n", "<S-C-d>", function()
    require("opencode").command("session.half.page.down")
  end, { desc = "Scroll OpenCode down" })

  -- Handle OpenCode events
  local OPENCODE_BUILTIN_TOOLS = {
    invalid = true,
    question = true,
    bash = true,
    read = true,
    glob = true,
    grep = true,
    edit = true,
    write = true,
    task = true,
    webfetch = true,
    todowrite = true,
    websearch = true,
    skill = true,
    apply_patch = true,
    submit_plan = true,
  }

  vim.api.nvim_create_autocmd("User", {
    pattern = "OpencodeEvent:*", -- Optionally filter event types
    callback = function(args)
      local event = args.data.event

      if event.type == "server.connected" then
        vim.notify("OpenCode connected", vim.log.levels.INFO)
      elseif event.type == "server.instance.disposed" then
        vim.notify("OpenCode disconnected", vim.log.levels.WARN)
      elseif event.type == "file.edited" then
        vim.notify("OpenCode edited a file", vim.log.levels.INFO)
      elseif event.type == "permission.asked" and event.properties then
        vim.notify("OpenCode wants permission: " .. event.properties.permission, vim.log.levels.WARN)
      elseif event.type == "session.status" and event.properties then
        local status = event.properties.status.type
        if status == "idle" then
          vim.notify("OpenCode finished", vim.log.levels.INFO)
        elseif status == "error" then
          vim.notify("OpenCode error", vim.log.levels.ERROR)
        end
      elseif event.type == "message.part.updated" and event.properties then
        local part = event.properties.part
        ---@diagnostic disable-next-line: unnecessary-if
        if part.type == "tool" and part.state.status == "completed" and not OPENCODE_BUILTIN_TOOLS[part.tool] then
          vim.notify("OpenCode used MCP tool: " .. part.tool, vim.log.levels.INFO)
        end
      end
    end,
  })
end)

Config.now(function()
  require("cursortab").setup({
    keymaps = {
      accept = "<Tab>", -- Blink overrides this in insert mode.
      partial_accept = "<S-Tab>", -- Blink overrides this in insert mode.
    },
    blink = {
      enabled = true,
      ghost_text = false, -- Disable native ghost text
    },
    provider = {
      type = "mercuryapi",
      api_key_env = "MERCURY_AI_TOKEN",

      -- Qwen3.5-0.8B (fastest local, defaults to "inline")
      -- url = "http://localhost:8000",
      -- model = "mlx-community/Qwen3.5-0.8B-MLX-4bit",

      -- sweep-next-edit-0.5B/1.5B (fastest local)
      -- type = "sweep",
      -- url = "http://localhost:8000",
      -- model = "Chris-Kode/sweep-next-edit-1.5b-mlx",
    },
  })
end)
