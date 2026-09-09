if vim.g.vscode then
  local redraw_fix = vim.api.nvim_create_augroup("VSCodeRedrawFix", { clear = true })

  -- Redraw on cursor hold to fix visual artifacts
  vim.api.nvim_create_autocmd("CursorHold", {
    group = redraw_fix,
    callback = function()
      vim.cmd("silent! mode") -- triggers a lightweight redraw
    end,
  })

  -- Redraw immediately after text changes (e.g., visual delete)
  local redraw_group = vim.api.nvim_create_augroup("RedrawOnDelete", { clear = true })
  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    group = redraw_group,
    callback = function()
      if vim.fn.mode() == "n" then
        vim.cmd("silent! mode") -- refresh UI after delete/insert
      end
    end,
  })

  -- Redraw on visual mode exit to fix selection artifacts
  vim.api.nvim_create_autocmd("ModeChanged", {
    group = redraw_fix,
    callback = function()
      vim.cmd("silent! mode")
    end,
  })

  -- Redraw on window operations
  vim.api.nvim_create_autocmd({ "WinEnter", "WinLeave" }, {
    group = redraw_fix,
    callback = function()
      vim.cmd("silent! mode")
    end,
  })
else
  local group = vim.api.nvim_create_augroup("nvim_minimax", { clear = true })

  vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    callback = function()
      vim.hl.hl_op()
    end,
  })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp_attach_disable_hover", { clear = true }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client == nil then
        return
      end
      if client.server_capabilities == nil then
        return
      end
      if client.name == "ruff" then
        client.server_capabilities.hoverProvider = false
      end
    end,
    desc = "LSP: Disable hover capability from specific LSP",
  })

  -- Toggle relative numbers on entering/leaving visual mode
  vim.api.nvim_create_autocmd("ModeChanged", {
    callback = function()
      local mode = vim.api.nvim_get_mode().mode
      if mode == "v" or mode == "V" or mode == "\22" then
        vim.opt.relativenumber = true
      else
        vim.opt.relativenumber = false
      end
    end,
    group = group,
  })

  -- Close sidebar windows with q
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = {
      "Outline",
      "OverseerOutput",
      "dap-float",
      "gitsigns-blame",
      "grug-far",
      "help",
      "neotest-output",
      "neotest-output-panel",
      "neotest-summary",
      "opencode",
      "opencode_output",
      "qf",
      "Avante",
      "AvanteInput",
    },
    callback = function(event)
      vim.bo[event.buf].buflisted = false
      vim.schedule(function()
        vim.keymap.set("n", "q", function()
          vim.cmd("close")
          pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
        end, {
          buffer = event.buf,
          silent = true,
          desc = "Quit buffer",
        })
      end)
    end,
  })
end

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

vim.api.nvim_create_user_command("ClearCursors", function()
  local mc_ns = vim.api.nvim_create_namespace("nvim.multicursor")
  vim.api.nvim_buf_clear_namespace(0, mc_ns, 0, -1)
  -- Force a redraw to update the UI immediately
  vim.cmd("redraw")
end, {})

vim.api.nvim_create_user_command("LspLog", function()
  vim.cmd.tabnew({ vim.lsp.log.get_filename() })
end, {
  desc = "Opens the Nvim LSP client log.",
})
