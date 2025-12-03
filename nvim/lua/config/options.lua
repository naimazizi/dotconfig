---@diagnostic disable: missing-fields, assign-type-mismatch
-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.o.spell = false

if not vim.g.vscode then
  -- ordinary Neovim

  vim.g.lazyvim_picker = "fzf"
  vim.g.root_spec = { "cwd" }
  vim.g.lazyvim_blink_main = true
  vim.g.snacks_animate = false

  vim.g.slime_target = "tmux"
  vim.g.slime_cell_delimiter = "# %%"
  vim.g.slime_bracketed_paste = 1

  vim.o.conceallevel = 0
  vim.o.mousemoveevent = true
  vim.opt.spell = false

  -- custom global variables
  vim.g.md_ft = { "markdown", "quarto", "hurl" }
  vim.g.md_injected_ft = { "markdown", "quarto" }
  vim.g.sql_ft = { "sql", "mysql", "plsql" }
  vim.g.sh_ft = { "sh", "bash", "zsh", "ksh" }

  local function system(command)
    local file = io.popen(command, "r")
    local output = file:read("*all"):gsub("%s+", "")
    file:close()
    return output
  end

  vim.g.python3_host_prog = system("which python")
elseif vim.g.vscode then
end
