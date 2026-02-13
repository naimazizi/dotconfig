local opt = vim.opt

opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus" -- Sync with system clipboard
opt.cursorline = true
opt.expandtab = true
opt.fillchars = { foldopen = "", foldclose = "", fold = " ", foldsep = " ", diff = "╱", eob = " " }
opt.foldlevel = 99
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.lsp.foldexpr()"
opt.foldtext = ""
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true
opt.incsearch = true
opt.laststatus = 0
opt.number = true
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true -- Round indent
opt.shiftwidth = 2
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = true
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true
opt.tabstop = 2
opt.termguicolors = true
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
opt.undofile = true
opt.updatetime = 250
opt.wrap = true

vim.o.breakindent = true
vim.o.scrolloff = 10
vim.o.confirm = true
vim.o.mouse = "a"
vim.o.autoread = true
vim.o.autowrite = true
vim.o.inccommand = "split"
vim.o.cursorline = true

vim.o.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

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
