local opt = vim.opt

opt.number = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true

opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

opt.splitbelow = true
opt.splitright = true

opt.updatetime = 250
opt.timeoutlen = 300 -- LazyVim-ish

opt.undofile = true

opt.clipboard = "unnamedplus"

opt.laststatus = 0
opt.splitkeep = "screen"

vim.o.scrolloff = 10
vim.o.confirm = true
vim.o.mouse = "a"

-- custom global variables
vim.g.md_ft = { "markdown", "quarto", "copilot-chat", "opencode_output", "Avante" }
vim.g.md_injected_ft = { "markdown", "quarto" }
vim.g.sql_ft = { "sql", "mysql", "plsql" }
vim.g.sh_ft = { "sh", "bash", "zsh", "ksh" }

vim.g.slime_target = "tmux"
vim.g.slime_cell_delimiter = "# %%"
vim.g.slime_bracketed_paste = 1

if vim.g.neovide then
  vim.env.PATH = "/opt/homebrew/bin:" .. vim.env.PATH
  vim.env.PATH = "/home/linuxbrew/.linuxbrew/bin:" .. vim.env.PATH
end
