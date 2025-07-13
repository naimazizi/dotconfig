---@diagnostic disable: missing-fields
-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- local function paste()
--   return {
--     vim.fn.split(vim.fn.getreg(""), "\n"),
--     vim.fn.getregtype(""),
--   }
-- end
--
-- vim.o.clipboard = "unnamedplus"
--
-- vim.g.clipboard = {
--   name = "OSC 52",
--   copy = {
--     ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
--     ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
--   },
--   paste = {
--     ["+"] = paste,
--     ["*"] = paste,
--   },
-- }

if not vim.g.vscode then
  -- ordinary Neovim
  if vim.fn.executable("fish") == 1 then
    vim.o.shell = "fish"
  end

  vim.g.lazyvim_picker = "snacks"
  vim.g.root_spec = { "cwd" }

  vim.o.smoothscroll = true
  vim.o.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
  vim.o.foldmethod = "expr"
  vim.o.guifont = "JetBrains Maple Mono:h11:#e-subpixelantialias"

  vim.g.copilot_nes_enabled = false
end
