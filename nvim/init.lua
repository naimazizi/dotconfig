vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.lazy")
require("config.options")
require("config.ui2")
require("config.keymaps")
require("config.autocmds")

require("lazy").setup({
  { import = "plugins" },
}, require("config.lazy_opts"))
