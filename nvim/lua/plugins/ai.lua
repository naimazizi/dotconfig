if vim.g.vscode then
  return
end

Config.on_packchanged("pi-x-ide", { "update" }, function(data)
  vim.opt.rtp:prepend(data.path .. "/ide-plugins/nvim")
  if not require("pi_x_ide.download").run({ refresh = true }) then
    vim.notify("Failed to refresh pi-x-ide sidecar; check the preceding warning", vim.log.levels.WARN)
  end
end, "Refresh pi-x-ide sidecar")

vim.pack.add({
  Config.gh("balaenis/pi-x-ide"),
  Config.gh("milanglacier/minuet-ai.nvim"),
})

Config.later(function()
  local plugin = vim.pack.get({ "pi-x-ide" })[1]
  if not plugin then
    error("pi-x-ide package is not installed")
  end
  vim.opt.rtp:prepend(plugin.path .. "/ide-plugins/nvim")
  require("pi_x_ide").setup({ keymap = "<leader>aa" })

  ---@type { buf_valid: fun(self: table): boolean, toggle: fun(self: table), win: integer? }?
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
  map({ "n", "i", "t", "x" }, "<C-;>", toggle_pi_focus, { desc = "Focus Pi-Bolt / source buffer" })
  map("n", "<S-C-;>", function()
    source_win = vim.api.nvim_get_current_win()
    toggle_pi()
  end, { desc = "Toggle Pi-Bolt sidebar" })

  local function copy_pi_prompt(lines)
    if vim.fn.has("clipboard") == 0 then
      vim.notify("Could not copy Pi prompt: clipboard provider unavailable", vim.log.levels.ERROR)
      return
    end
    local ok, result = pcall(vim.fn.setreg, "+", table.concat(lines, "\n"))
    if not ok or result ~= 0 then
      vim.notify("Could not copy Pi prompt: " .. tostring(result), vim.log.levels.ERROR)
      return
    end
    vim.notify("Copied Pi prompt to clipboard", vim.log.levels.INFO)
  end

  local function format_pi_diagnostic(path, diagnostic)
    local namespace = vim.diagnostic.get_namespace(diagnostic.namespace).name
    local lsp = namespace and namespace:match("^nvim%.lsp%.(.-)%.%d+")
    local details = vim.diagnostic.severity[diagnostic.severity]
    if lsp then
      details = details .. ", LSP: " .. lsp
    end
    if diagnostic.source and diagnostic.source ~= "" then
      details = details .. ", source: " .. diagnostic.source
    end
    return ("%s:%d:%d [%s] %s"):format(path, diagnostic.lnum + 1, diagnostic.col + 1, details, diagnostic.message)
  end

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
      lines[#lines + 1] = format_pi_diagnostic(path, diagnostic)
    end
    copy_pi_prompt(lines)
  end, { desc = "Copy current file diagnostics for Pi" })
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
      lines[#lines + 1] = format_pi_diagnostic(path, diagnostic)
    end
    copy_pi_prompt(lines)
  end, { desc = "Copy all diagnostics for Pi" })
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
    copy_pi_prompt(lines)
  end, { desc = "Copy quickfix list for Pi" })
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
  local ignored_patterns = vim.tbl_map(vim.fn.glob2regpat, {
    "*.min.js",
    "*.min.css",
    "*.map",
    "*-lock.json",
    "*.lock",
    "*.sum",
    "*.csv",
    "*.tsv",
    "*.parquet",
    "*.zip",
    "*.tar",
    "*.gz",
    "*.pem",
    "*.key",
    ".env",
    ".env.*",
    "*.log",
  })
  local ignored = {}
  Config.new_autocmd({ "BufEnter", "BufFilePost", "DirChanged" }, "*", function()
    ignored = {}
  end, "Refresh Minuet file exclusions")

  local function completion_allowed(bufnr)
    local path = vim.api.nvim_buf_get_name(bufnr)
    local name = vim.fn.fnamemodify(path, ":t")
    if
      path == ""
      or vim.bo[bufnr].buftype ~= ""
      or vim.bo[bufnr].filetype == ""
      or not vim.bo[bufnr].modifiable
      or vim.bo[bufnr].readonly
    then
      return false
    end
    for _, pattern in ipairs(ignored_patterns) do
      if vim.fn.match(name, pattern) >= 0 then
        return false
      end
    end
    if ignored[path] == nil then
      if vim.fn.executable("git") == 0 then
        ignored[path] = true
        vim.notify("Minuet disabled: install git to check ignored files", vim.log.levels.WARN)
      else
        local result =
          vim.system({ "git", "-C", vim.fn.fnamemodify(path, ":h"), "check-ignore", "--quiet", "--", path }):wait()
        local outside_repo = result.code == 128 and (result.stderr or ""):find("not a git repository", 1, true)
        ignored[path] = result.code ~= 1 and not outside_repo
        if ignored[path] and result.code ~= 0 then
          vim.notify("Minuet disabled: git could not check whether this file is ignored", vim.log.levels.WARN)
        end
      end
    end
    return not ignored[path]
  end

  local function current_completion_allowed()
    return completion_allowed(vim.api.nvim_get_current_buf())
  end

  require("minuet").setup({
    provider = "openai_fim_compatible",
    provider_options = {
      openai_fim_compatible = {
        name = "Mercury",
        end_point = "https://api.inceptionlabs.ai/v1/fim/completions",
        api_key = "MERCURY_AI_TOKEN",
        model = "mercury-edit-2",
      },
    },
    n_completions = 1,
    virtualtext = {
      auto_trigger_ft = { "*" },
      keymap = { accept = "<M-a>", accept_line = "<M-s>" },
    },
    enable_predicates = { current_completion_allowed },
    duet = {
      provider = "openai_compatible",
      provider_options = {
        openai_compatible = {
          name = "Mercury",
          end_point = "https://api.inceptionlabs.ai/v1/chat/completions",
          api_key = "MERCURY_AI_TOKEN",
          model = "mercury-3",
          optional = { reasoning_effort = "instant" },
        },
      },
      recent_edits = { enable_predicates = { completion_allowed } },
      auto_trigger = { enable_predicates = { current_completion_allowed } },
    },
  })

  vim.keymap.set("n", "<leader>ap", function()
    if not current_completion_allowed() then
      vim.notify("Minuet prediction disabled for this file", vim.log.levels.WARN)
      return
    end
    require("minuet.duet").action.predict()
  end, { desc = "Predict next edit" })
  vim.keymap.set("n", "<leader>ae", function()
    require("minuet.duet").action.apply()
  end, { desc = "Apply predicted edit" })
  vim.keymap.set("n", "<leader>ax", function()
    require("minuet.duet").action.dismiss()
  end, { desc = "Dismiss predicted edit" })
end)
