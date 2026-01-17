-- Minimal entrypoint. Everything else lives in `lua/`.
--
-- Launch with `NVIM_APPNAME=nvim-minimax nvim` so data/state are isolated.

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.lazy")
require("config.options")
require("config.keymaps")
require("config.autocmds")

require("lazy").setup({
	{ import = "plugins" },
}, require("config.lazy_opts"))
