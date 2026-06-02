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
      vim.hl.on_yank()
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

  -- Toggle relative numbers: on in normal/visual mode, off in insert mode
  vim.api.nvim_create_autocmd("ModeChanged", {
    callback = function()
      local mode = vim.fn.mode()
      local in_visual = mode:find("^[vV\22]") ~= nil
      local in_insert = mode:find("^[iR]") ~= nil
      if in_insert then
        vim.opt_local.relativenumber = false
      elseif in_visual or mode == "n" then
        vim.opt_local.relativenumber = true
      end
    end,
    group = group,
  })

  -- Barbar: safe tabline before mksession save
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "PersistenceSavePre",
    callback = function()
      vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePre" })
    end,
  })

  vim.api.nvim_create_user_command("LspLog", function()
    vim.cmd.tabnew({ vim.lsp.log.get_filename() })
  end, {
    desc = "Opens the Nvim LSP client log.",
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
