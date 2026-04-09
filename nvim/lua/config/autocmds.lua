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

  -- Aggressive redraw on cursor movement in visual mode
  vim.api.nvim_create_autocmd("CursorMoved", {
    group = redraw_fix,
    callback = function()
      local mode = vim.fn.mode()
      if mode:match("[vV\22]") then
        vim.cmd("silent! mode")
      end
    end,
  })
else
  local group = vim.api.nvim_create_augroup("nvim_minimax", { clear = true })

  vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    callback = function()
      vim.highlight.on_yank()
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

  vim.api.nvim_create_autocmd("FocusGained", {
    desc = "Reload files from disk when we focus vim",
    pattern = "*",
    command = "if getcmdwintype() == '' | checktime | endif",
    group = group,
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    desc = "Every time we enter an unmodified buffer, check if it changed on disk",
    pattern = "*",
    command = "if &buftype == '' && !&modified && expand('%') != '' | exec 'checktime ' . expand('<abuf>') | endif",
    group = group,
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

  -- Barbar: safe tabline before mksession save
  vim.api.nvim_create_autocmd("User", {
    pattern = "PersistenceSavePre",
    callback = function()
      vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePre" })
    end,
  })

  -- Quicker.nvim: configure behavior on quickfix open
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    group = group,
    callback = function(args)
      local buf = args.buf
      -- Prevent quickfix from changing the window layout
      vim.bo[buf].buflisted = false
      -- Ensure it doesn't create new windows/buffers when opening items
      vim.keymap.set("n", "<CR>", function()
        -- Use the quicker API to open the item in the current window
        vim.api.nvim_win_close(vim.api.nvim_get_current_win(), false)
        vim.cmd("execute 'cc ' . line('.')")
      end, { buffer = buf, noremap = true, silent = true })
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "msg",
    callback = function()
      local ui2 = require("vim._core.ui2")
      local win = ui2.wins and ui2.wins.msg
      if win and vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_set_option_value(
          "winhighlight",
          "Normal:NormalFloat,FloatBorder:FloatBorder",
          { scope = "local", win = win }
        )
      end
    end,
  })

  local ui2 = require("vim._core.ui2")
  local msgs = require("vim._core.ui2.messages")
  local orig_set_pos = msgs.set_pos
  ---@diagnostic disable-next-line: duplicate-set-field
  msgs.set_pos = function(tgt)
    orig_set_pos(tgt)
    if (tgt == "msg" or tgt == nil) and vim.api.nvim_win_is_valid(ui2.wins.msg) then
      pcall(vim.api.nvim_win_set_config, ui2.wins.msg, {
        relative = "editor",
        anchor = "SE",
        row = vim.o.lines - 1,
        col = vim.o.columns - 1,
        border = "rounded",
      })
    end
  end

  vim.api.nvim_create_autocmd("LspProgress", {
    callback = function(ev)
      local value = ev.data.params.value
      vim.api.nvim_echo({ { value.message or "done" } }, false, {
        id = "lsp." .. ev.data.client_id,
        kind = "progress",
        source = "vim.lsp",
        title = value.title,
        status = value.kind ~= "end" and "running" or "success",
        percent = value.percentage,
      })
    end,
  })
end
