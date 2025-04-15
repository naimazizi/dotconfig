---@diagnostic disable: missing-fields
-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
if vim.g.vscode then
  -- VSCode extension
  vim.keymap.set({ "n", "x", "i" }, "<C-d>", function()
    require("vscode-multi-cursor").addSelectionToNextFindMatch()
  end)
else
  -- ordinary Neovim
  if vim.fn.executable("fish") == 1 then
    vim.o.shell = "fish"
  end

  vim.g.lazyvim_picker = "snacks"
  vim.g.root_spec = { "cwd" }

  -- python config
  -- vim.g.lazyvim_python_lsp = "basedpyright" -- Use pyright for the time being, basedpyright is slow
  vim.g.lazyvim_python_ruff = "ruff"
end
