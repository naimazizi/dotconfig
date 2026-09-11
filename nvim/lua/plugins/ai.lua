if vim.g.vscode then
  return
end

vim.pack.add({
  Config.gh("nickjvandyke/opencode.nvim"),
  Config.gh("cursortab/cursortab.nvim"),
})

Config.on_packchanged("cursortab.nvim", { "install", "update" }, function(data)
  vim.async.run(function()
    local result = vim.async.await(3, vim.system, { "go", "build" }, { cwd = data.path .. "/server" })
    if result.code ~= 0 then
      local output = (result.stderr ~= "" and result.stderr) or result.stdout or "No output from build command."
      vim.notify(("Build failed for cursortab.nvim:\n%s"):format(output), vim.log.levels.ERROR)
    end
  end)
end, "Build cursortab.nvim server")

Config.later(function()
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
      ---@type opencode.server.Event
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

-- cursortab.nvim -- was `lazy = false` ("The server is already lazy loaded")
Config.now(function()
  require("cursortab").setup({
    keymaps = {
      accept = false, -- <Tab> is driven by blink's keymap instead
      partial_accept = false, -- <S-Tab> is driven by blink's keymap instead
    },
    provider = {
      -- Qwen3.5-0.8B (fastest local, defaults to "inline")
      url = "http://localhost:8000",
      model = "mlx-community/Qwen3.5-0.8B-MLX-4bit",

      -- sweep-next-edit-0.5B/1.5B (fastest local)
      -- type = "sweep",
      -- url = "http://localhost:8000",
      -- model = "Chris-Kode/sweep-next-edit-1.5b-mlx",
    },
  })
end)
