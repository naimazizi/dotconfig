-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
if vim.fn.executable("fish") == 1 then
  vim.o.shell = "fish"
end

local opt = vim.opt
opt.conceallevel = 0
opt.clipboard = "unnamedplus"

-- python config
vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_ruff = "ruff"

opts = function()
  ---@class PluginLspOpts
  local ret = {
    ---@type lspconfig.options
    servers = {
      basedpyright = {
        typeCheckingMode = "strict",
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "openFilesOnly",
          useLibraryCodeForTypes = true,
        },
      },
    },
  }
  return ret
end
