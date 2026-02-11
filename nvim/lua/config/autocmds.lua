if vim.g.vscode then
  local redraw_fix = vim.api.nvim_create_augroup("VSCodeRedrawFix", { clear = true })
  vim.api.nvim_create_autocmd("CursorHold", {
    group = redraw_fix,
    callback = function()
      vim.cmd("silent! mode") -- triggers a lightweight redraw
    end,
  })

  -- 2. Redraw immediately after text changes (e.g., visual delete)
  local redraw_group = vim.api.nvim_create_augroup("RedrawOnDelete", { clear = true })
  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    group = redraw_group,
    callback = function()
      if vim.fn.mode() == "n" then
        vim.cmd("silent! mode") -- refresh UI after delete/insert
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

  -- Trouble: replace quickfix/location-list UI (LazyVim-ish)
  local function trouble_open(mode)
    local ok, trouble = pcall(require, "trouble")
    if not ok then
      return false
    end
    trouble.open({ mode = mode })
    return true
  end

  -- Replace the built-in quickfix/location-list commands at the command-line.
  -- Note: we can't override built-in Ex commands directly, so we use cmdline
  -- abbreviations + a FileType(qf) redirect as a safety net for plugins.
  vim.cmd([[cnoreabbrev <expr> copen   (getcmdtype() ==# ':' && getcmdline() ==# 'copen')   ? 'Copen'   : 'copen']])
  vim.cmd([[cnoreabbrev <expr> cclose  (getcmdtype() ==# ':' && getcmdline() ==# 'cclose')  ? 'Cclose'  : 'cclose']])
  vim.cmd([[cnoreabbrev <expr> cwindow (getcmdtype() ==# ':' && getcmdline() ==# 'cwindow') ? 'Cwindow' : 'cwindow']])
  vim.cmd([[cnoreabbrev <expr> lopen   (getcmdtype() ==# ':' && getcmdline() ==# 'lopen')   ? 'Lopen'   : 'lopen']])
  vim.cmd([[cnoreabbrev <expr> lclose  (getcmdtype() ==# ':' && getcmdline() ==# 'lclose')  ? 'Lclose'  : 'lclose']])
  vim.cmd([[cnoreabbrev <expr> lwindow (getcmdtype() ==# ':' && getcmdline() ==# 'lwindow') ? 'Lwindow' : 'lwindow']])

  vim.api.nvim_create_user_command("Copen", function()
    if not trouble_open("quickfix") then
      vim.cmd("copen")
    end
  end, { desc = "Open quickfix (Trouble)" })

  vim.api.nvim_create_user_command("Cwindow", function()
    if vim.tbl_isempty(vim.fn.getqflist()) == 1 then
      return
    end
    if not trouble_open("quickfix") then
      vim.cmd("cwindow")
    end
  end, { desc = "Open quickfix if there are items (Trouble)" })

  vim.api.nvim_create_user_command("Cclose", function()
    local ok, trouble = pcall(require, "trouble")
    if ok then
      trouble.close({ mode = "quickfix" })
      return
    end
    vim.cmd("cclose")
  end, { desc = "Close quickfix (Trouble)" })

  vim.api.nvim_create_user_command("Lopen", function()
    if not trouble_open("loclist") then
      vim.cmd("lopen")
    end
  end, { desc = "Open loclist (Trouble)" })

  vim.api.nvim_create_user_command("Lwindow", function()
    if vim.tbl_isempty(vim.fn.getloclist(0)) == 1 then
      return
    end
    if not trouble_open("loclist") then
      vim.cmd("lwindow")
    end
  end, { desc = "Open loclist if there are items (Trouble)" })

  vim.api.nvim_create_user_command("Lclose", function()
    local ok, trouble = pcall(require, "trouble")
    if ok then
      trouble.close({ mode = "loclist" })
      return
    end
    vim.cmd("lclose")
  end, { desc = "Close loclist (Trouble)" })

  -- If something opens a real quickfix window anyway, redirect it to Trouble.
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "qf",
    callback = function(args)
      if vim.g.trouble_replace_qf == false then
        return
      end

      if vim.bo[args.buf].buftype ~= "quickfix" then
        return
      end

      if vim.b[args.buf]._trouble_redirected then
        return
      end
      vim.b[args.buf]._trouble_redirected = true

      local wininfo = vim.fn.getwininfo(vim.fn.win_getid())
      local is_loclist = (wininfo[1] and wininfo[1].loclist == 1) or false
      local mode = is_loclist and "loclist" or "quickfix"

      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(args.buf) then
          return
        end

        pcall(vim.api.nvim_win_close, vim.fn.bufwinid(args.buf), true)
        trouble_open(mode)
      end)
    end,
    desc = "Redirect quickfix windows to Trouble",
  })
end
