local opt = vim.opt

opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus" -- Sync with system clipboard
opt.cursorline = vim.g.vscode and false or true
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
opt.laststatus = 3
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

vim.g.disable_autoformat = true

vim.o.cmdheight = 1
require("vim._core.ui2").enable({
  enable = true,
  msg = {
    targets = {
      [""] = "msg",
      empty = "cmd",
      bufwrite = "msg",
      confirm = "cmd",
      emsg = "pager",
      echo = "msg",
      echomsg = "msg",
      echoerr = "pager",
      completion = "cmd",
      list_cmd = "pager",
      lua_error = "pager",
      lua_print = "msg",
      progress = "pager",
      rpc_error = "pager",
      quickfix = "msg",
      search_cmd = "cmd",
      search_count = "cmd",
      shell_cmd = "pager",
      shell_err = "pager",
      shell_out = "pager",
      shell_ret = "msg",
      undo = "msg",
      verbose = "pager",
      wildlist = "cmd",
      wmsg = "msg",
      typed_cmd = "cmd",
    },
    cmd = {
      height = 0.5,
    },
    dialog = {
      height = 0.5,
    },
    msg = {
      height = 0.3,
      timeout = 5000,
    },
    pager = {
      height = 0.5,
    },
  },
})

if vim.g.neovide then
  vim.env.PATH = "/opt/homebrew/bin:" .. vim.env.PATH
  vim.env.PATH = "/home/linuxbrew/.linuxbrew/bin:" .. vim.env.PATH
  vim.g.neovide_cursor_trail_size = 0
end
