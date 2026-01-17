return {
  {
    "akinsho/toggleterm.nvim",
event= "VeryLazy",
vscode = false,
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    opts = {
      open_mapping = [[<c-/>]],
      insert_mappings = true,
      terminal_mappings = true,
      start_in_insert = true,
      shade_terminals = true,
      on_open = function(term)
        vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = term.bufnr, silent = true })
      end,
    },
  },
}
