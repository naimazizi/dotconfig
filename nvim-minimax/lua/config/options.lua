local opt = vim.opt

opt.number = true
opt.relativenumber = true
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

opt.completeopt = { "menuone", "noselect" }


-- custom global variables
vim.g.md_ft = { "markdown", "quarto", "copilot-chat", "opencode_output", "Avante" }
vim.g.md_injected_ft = { "markdown", "quarto" }
vim.g.sql_ft = { "sql", "mysql", "plsql" }
vim.g.sh_ft = { "sh", "bash", "zsh", "ksh" }
