return {
  {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    vscode = false,
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    config = function()
      require("toggleterm").setup({
        insert_mappings = true,
        terminal_mappings = true,
        start_in_insert = true,
        shade_terminals = false,
        open_mapping = [[<c-/>]],
        on_open = function(term)
          vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = term.bufnr, silent = true })
        end,
        highlights = {
          Normal = {
            guibg = "#2A2A37",
          },
        },
      })

      local Terminal = require("toggleterm.terminal").Terminal
      local term = Terminal:new({
        cmd = "zsh",
        close_on_exit = true,
        auto_scroll = true,
        on_open = function()
          vim.cmd("startinsert!")
        end,
        on_close = function()
          vim.cmd("startinsert!")
        end,
      })

      function _terminal_toggle()
        term:toggle()
      end

      vim.api.nvim_set_keymap(
        "n",
        "<leader>ft",
        "<cmd>lua _terminal_toggle()<CR>",
        { silent = true, desc = "Toggle terminal" }
      )
    end,
  },
}
