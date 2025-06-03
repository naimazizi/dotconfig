---@diagnostic disable: missing-fields
-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
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
  vim.o.foldtext = ""

  -- vim.g.lazyvim_python_lsp = "basedpyright" -- Use pyright for the time being, basedpyright is slow
  vim.g.lazyvim_python_ruff = "ruff"
end
