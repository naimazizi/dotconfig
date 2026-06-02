vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.lazy")
require("config.options")
require("config.keymaps")
require("config.autocmds")

require("lazy").setup({
  { import = "plugins" },
  { import = "plugins.lang" },
}, require("config.lazy_opts"))
