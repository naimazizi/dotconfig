if vim.g.vscode then
  return
end

local uniq = require("utils.table").uniq

vim.pack.add({
  Config.gh("mason-org/mason.nvim"),
  Config.gh("mason-org/mason-lspconfig.nvim"),
  Config.gh("neovim/nvim-lspconfig"),
  Config.gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
})

Config.now(function()
  local ensure_installed = uniq({
    "ast-grep",
    "bacon",
    "bacon-ls",
    "debugpy",
    "emmylua_ls",
    "harper-ls",
    "jq",
    "json-lsp",
    "jupytext",
    "kdlfmt",
    "mmdc",
    "oxfmt",
    "panache",
    "pyrefly",
    "ruff",
    "rust-analyzer",
    "shfmt",
    "sqlfmt",
    "stylua",
    "tinymist",
    "typos-lsp",
    "typstyle",
    "yaml-language-server",
    "zk",
  })

  require("mason").setup({
    ui = { border = "rounded" },
  })

  local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
  if not vim.env.PATH:find(mason_bin, 1, true) then
    vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
  end

  require("mason-lspconfig").setup({
    automatic_enable = true,
  })

  require("mason-tool-installer").setup({
    ensure_installed = ensure_installed,
    run_on_start = true,
    start_delay = 0,
  })

  vim.keymap.set("n", "<leader>cm", "<cmd>Mason<cr>", { desc = "Mason" })
end)
