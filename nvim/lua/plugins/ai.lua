if vim.g.vscode then
  return
end

Config.on_packchanged("avante.nvim", { "install", "update" }, function(data)
  local result = vim.system({ "make" }, { cwd = data.path, text = true }):wait()
  if result.code ~= 0 then
    error(("Avante build failed (requires make and cargo):\n%s\n%s"):format(result.stderr, result.stdout))
  end
end, "Build Avante native libraries")

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
  Config.gh("nvim-lua/plenary.nvim"),
  Config.gh("MunifTanjim/nui.nvim"),
  Config.gh("ColinKennedy/mega.logging"),
  Config.gh("ColinKennedy/mega.cmdparse"),
  Config.gh("yetone/avante.nvim"),
  Config.gh("cursortab/cursortab.nvim"),
})

Config.later(function()
  require("avante").setup({
    provider = "pi",
    acp_providers = {
      pi = {
        command = "pi-bolt",
        args = { "--acp" },
      },
    },
    behaviour = {
      auto_approve_tool_permissions = false, -- ACP also uses permission requests for user questions.
      acp_follow_agent_locations = true, -- Keep your cursor where you are.
      show_token_usage = true,
    },
    prompt_logger = {
      prev_prompt = { normal = "<Up>", insert = "<Up>" },
      next_prompt = { normal = "<Down>", insert = "<Down>" },
    },
    windows = {
      width = 38, -- Percentage of editor width.
      input = { height = 12 },
    },
    slash_commands = {
      {
        name = "diagnostics",
        description = "Ask about the source buffer's errors and warnings",
        callback = function(sidebar, args)
          local bufnr = sidebar.code.bufnr
          if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
            vim.notify("Avante source buffer is unavailable", vim.log.levels.ERROR)
            return
          end
          local diagnostics = vim.diagnostic.get(bufnr, {
            severity = { min = vim.diagnostic.severity.WARN, max = vim.diagnostic.severity.ERROR },
          })
          if #diagnostics == 0 then
            vim.notify("No errors or warnings in the source buffer", vim.log.levels.INFO)
            return
          end

          local lines = {}
          for _, diagnostic in ipairs(diagnostics) do
            lines[#lines + 1] = ("%s %d:%d [%s] %s"):format(
              vim.diagnostic.severity[diagnostic.severity],
              diagnostic.lnum + 1,
              diagnostic.col + 1,
              diagnostic.source or "unknown",
              diagnostic.message
            )
          end
          sidebar:handle_submit(
            ("%s\nDiagnostics for %s:\n%s"):format(
              args ~= "" and args or "Explain and fix these diagnostics.",
              vim.api.nvim_buf_get_name(bufnr),
              table.concat(lines, "\n")
            )
          )
        end,
      },
    },
  })

  local function clear_selected_code(sidebar)
    sidebar.code.selection = nil
    local selected_code = sidebar.containers.selected_code
    -- Detach first so Avante's WinClosed handler does not close the whole sidebar.
    sidebar.containers.selected_code = nil
    if selected_code then
      selected_code:unmount()
    end
  end

  local function focus_avante(selection)
    local utils = require("avante.utils")
    if utils.is_sidebar_buffer(0) then
      require("avante.api").focus()
      return
    end
    local bufnr = vim.api.nvim_get_current_buf()
    local filename = vim.api.nvim_buf_get_name(bufnr)
    if vim.bo[bufnr].buftype ~= "" or filename == "" then
      vim.notify("Avante context requires a named file buffer", vim.log.levels.WARN)
      return
    end
    local sidebar = require("avante").get(false)
    if sidebar and not sidebar:can_open() then
      return
    end
    if selection then
      vim.cmd("normal! \27")
    end
    if sidebar and sidebar:is_open() then
      local winid = vim.api.nvim_get_current_win()
      if sidebar.code.winid ~= winid then
        sidebar:recover_code_winhl()
        sidebar.code.winid = winid
        sidebar:set_code_winhl()
      end
      if sidebar.code.bufnr ~= bufnr or not vim.deep_equal(sidebar.file_selector.selected_filepaths, { filename }) then
        sidebar.code.bufnr = bufnr
        if not selection then
          clear_selected_code(sidebar)
        end
        -- reset() drops listeners; replace context and notify the existing view instead.
        sidebar.file_selector.selected_filepaths = { filename }
        sidebar.file_selector:emit("update")
      end
      if selection then
        sidebar.code.selection = selection
        if not sidebar.containers.selected_code then
          sidebar:create_selected_code_container()
        end
        local codebuf = sidebar.containers.selected_code.bufnr
        utils.unlock_buf(codebuf)
        vim.api.nvim_buf_set_lines(codebuf, 0, -1, false, vim.split(selection.content, "\n"))
        utils.lock_buf(codebuf)
        vim.treesitter.stop(codebuf)
        vim.bo[codebuf].syntax = vim.bo[bufnr].syntax
        sidebar:adjust_selected_code_container_layout()
        sidebar:render_selected_code()
      end
      sidebar:focus_input()
      return
    end
    if require("avante.api").ask({ selection = selection, floating = false }) then
      require("avante").get():focus_input()
    end
  end

  local map = vim.keymap.set
  map("n", "<C-;>", focus_avante, { desc = "avante: select current file / return to code" })
  map("i", "<C-;>", function()
    if require("avante.utils").is_sidebar_buffer(0) then
      focus_avante()
      return
    end
    local line = vim.api.nvim_get_current_line()
    local lnum = vim.api.nvim_win_get_cursor(0)[1]
    local range = require("avante.range"):new({ lnum = lnum, col = 1 }, { lnum = lnum, col = math.max(#line, 1) })
    local selection = require("avante.selection_result"):new(vim.api.nvim_buf_get_name(0), vim.bo.filetype, line, range)
    focus_avante(selection)
  end, { desc = "avante: attach current line as context / return to code" })
  map("x", "<C-;>", function()
    focus_avante(require("avante.utils").get_visual_selection_and_range())
  end, { desc = "avante: attach selected code as context" })
  map("n", "<leader>al", "<cmd>Avante acp sessions<cr>", { desc = "avante: acp session" })
  map("n", "<leader>ae", function()
    local sidebar = require("avante").get(false)
    if not sidebar then
      return
    end
    clear_selected_code(sidebar)
  end, { desc = "avante: clear selected code" })

  local function refresh_avante(buf)
    if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].filetype ~= "Avante" then
      return
    end
    local miniclue = require("mini.clue")
    local descriptions = {
      ["[p"] = "Previous prompt",
      ["]p"] = "Next prompt",
      ["[["] = "Previous code block",
      ["]]"] = "Next code block",
    }
    -- Real mappings override standalone clues, even when their desc is empty.
    for _, _map in ipairs(vim.api.nvim_buf_get_keymap(buf, "n")) do
      local desc = descriptions[_map.lhs]
      if desc and _map.desc ~= desc then
        vim.api.nvim_buf_call(buf, function()
          miniclue.set_mapping_desc("n", _map.lhs, desc)
        end)
      end
    end
    miniclue.ensure_buf_triggers(buf)
  end

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "Avante", "markdown.Avante" },
    callback = function(ev)
      -- Wait for Avante to render the saved chat without changing focus.
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(ev.buf) then
          require("avante.utils").buf_scroll_to_end(ev.buf)
        end
      end)
    end,
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function(ev)
      vim.schedule(function()
        refresh_avante(ev.buf)
      end)
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = "AvanteViewBufferUpdated",
    callback = function()
      vim.schedule(function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          refresh_avante(buf)
        end
      end)
    end,
  })
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
