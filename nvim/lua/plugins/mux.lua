if vim.g.vscode then
  return
end

vim.pack.add({ Config.gh("christoomey/vim-tmux-navigator"), Config.gh("aimdevlee/herdr-nvim-nav") })

Config.later(function()
  require("herdr-nvim-nav").setup({
    with_tmux = nil, -- nil = auto-detect $TMUX; true/false to force
    keymaps = { -- lhs list per direction; {} disables a direction
      left = { "<C-h>", "<C-Left>" },
      down = { "<C-j>", "<C-Down>" },
      up = { "<C-k>", "<C-Up>" },
      right = { "<C-l>", "<C-Right>" },
    },
    socket_path = nil, -- default: $HERDR_SOCKET_PATH or ~/.config/herdr/herdr.sock
    cache_dir = nil, -- default: $XDG_CACHE_HOME or ~/.cache
    herdr_bin = nil, -- default: $HERDR_BIN_PATH or "herdr"
    socket_timeout_ms = 150,
  })
end)
