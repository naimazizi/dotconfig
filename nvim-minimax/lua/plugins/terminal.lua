return {
  {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    vscode = false,
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    opts = {
      insert_mappings = true,
      terminal_mappings = true,
      start_in_insert = true,
      shade_terminals = true,
      on_open = function(term)
        vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = term.bufnr, silent = true })
      end,
    },
    config = function(opts)
      require("toggleterm").setup(opts)

      local Terminal = require("toggleterm.terminal").Terminal
      local term = Terminal:new({
        cmd = "zsh",
        direction = "vertical",
        hidden = true,
        close_on_exit = true,
        on_open = function(term)
          vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = term.bufnr, silent = true })
        end,
      })

      function _terminal_toggle()
        term:toggle()
      end

      vim.api.nvim_set_keymap(
        "n",
        "<c-/>",
        "<cmd>lua _terminal_toggle()<CR>",
        { silent = true, desc = "Toggle terminal" }
      )
    end,
  },
}
