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
  Config.gh("cursortab/cursortab.nvim"),
})

Config.later(function()
  require("pi-nvim").setup({ set_default_keymaps = false })

  local pi
  local pi_opts = {
    count = 1,
    cwd = vim.fn.getcwd(),
    win = {
      position = "float",
      backdrop = false,
      width = 0.30,
      height = function()
        return vim.o.lines - 10
      end,
      col = function()
        return vim.o.columns - math.floor(vim.o.columns * 0.30) - 4 -- Border plus two-column gap.
      end,
      border = "rounded",
      keys = {
        hide_pi = { "<S-C-;>", "hide", mode = "t", desc = "Hide Pi-Bolt sidebar" },
      },
      on_buf = function(term)
        local buf = term.buf
        vim.bo[buf].bufhidden = "hide"
        vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
          buffer = buf,
          command = "startinsert",
          desc = "Enter Pi terminal-input mode on focus",
        })
      end,
    },
  }
  local function toggle_pi()
    if not pi or not pi:buf_valid() then
      pi = Snacks.terminal.open({ "pi-bolt", "--continue" }, pi_opts)
    else
      pi:toggle()
    end
  end

  for _, key in ipairs({ "<ScrollWheelUp>", "<ScrollWheelDown>", "<ScrollWheelLeft>", "<ScrollWheelRight>" }) do
    vim.keymap.set({ "n", "x", "i", "t" }, key, function()
      local term = pi
      if
        term
        and vim.fn.getmousepos().winid == term.win
        and (vim.api.nvim_get_current_win() ~= term.win or vim.api.nvim_get_mode().mode ~= "t")
      then
        return ""
      end
      return key
    end, { expr = true, desc = "Scroll Pi sidebar only in terminal-input mode" })
  end

  -- Target only this sidebar's Pi process, never another session in the same directory.
  ---@type { get_socket_path: fun(): string? }
  local pi_bridge = require("pi-nvim")
  pi_bridge.get_socket_path = function()
    local term = pi
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
    local term = pi
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
      toggle_pi()
    end
  end

  local map = vim.keymap.set
  map({ "n", "i", "t" }, "<C-;>", toggle_pi_focus, { desc = "Focus Pi-Bolt / source buffer" })
  map("x", "<C-;>", function()
    local path = vim.api.nvim_buf_get_name(0)
    if path == "" or vim.bo.buftype ~= "" then
      vim.notify("Pi reference requires a named file buffer", vim.log.levels.WARN)
      return
    end
    local first, last = vim.fn.line("v"), vim.fn.line(".")
    local reference = ("%s:%d-%d "):format(path, math.min(first, last), math.max(first, last))
    toggle_pi_focus()
    if pi and pi:buf_valid() then
      vim.api.nvim_chan_send(vim.bo[pi.buf].channel, reference)
    else
      vim.notify("Could not open Pi terminal", vim.log.levels.ERROR)
    end
  end, { desc = "Focus Pi-Bolt and insert selection reference" })
  map("n", "<S-C-;>", function()
    source_win = vim.api.nvim_get_current_win()
    toggle_pi()
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
