---@diagnostic disable: missing-fields
-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local function paste()
  return {
    vim.fn.split(vim.fn.getreg(""), "\n"),
    vim.fn.getregtype(""),
  }
end

vim.o.spell = false

if not vim.g.vscode then
  -- ordinary Neovim
  if vim.fn.executable("fish") == 1 then
    vim.o.shell = "fish"
  end

  vim.g.lazyvim_picker = "snacks"
  vim.g.root_spec = { "cwd" }

  vim.o.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
  vim.o.foldmethod = "expr"
  vim.o.guifont = "JetBrains Maple Mono:h11:#e-subpixelantialias"
  vim.o.smoothscroll = false

  vim.g.copilot_nes_enabled = true

  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = paste,
      ["*"] = paste,
    },
  }
elseif vim.g.vscode then
  -- Fix ghost font
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
end
