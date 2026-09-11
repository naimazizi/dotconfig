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

if not vim.g.vscode then
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
