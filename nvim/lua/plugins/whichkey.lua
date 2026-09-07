if vim.g.vscode then
  return
end

vim.pack.add({ Config.gh("folke/which-key.nvim") })

Config.now(function()
  require("which-key").setup({
    preset = "helix",
    delay = 100,
    icons = {
      mappings = true,
    },
    spec = {
      { "<leader>a", group = "AI" },
      { "<leader>b", group = "buffer" },
      { "<leader>c", group = "code" },
      { "<leader>d", group = "debug" },
      { "<leader>f", group = "find" },
      { "<leader>g", group = "git" },
      { "<leader>s", group = "search" },
      { "<leader>q", group = "quit/session" },
      { "<leader>t", group = "test" },
      { "<leader>u", group = "ui" },
      { "<leader>o", group = "overseer", icon = "" },
      -- additional plugin
      { "<localleader>r", group = "REPL", icon = "" },
      { "<localleader>s", group = "Quarto", icon = "" },
      { "<localleader>c", group = "Curl (hurl)", icon = "󱂛" },
      { "gs", group = "Surround" },
      { "go", group = "Coerce" },
      { "<leader>dD", group = "DAP ft-specific" },
      { "<leader>h", group = "Haunting Notes", icon = "󱙝" },
    },
  })

  vim.keymap.set("n", "<leader>?", function()
    require("which-key").show({ global = false })
  end, { desc = "Buffer Keymaps (which-key)" })
end)
