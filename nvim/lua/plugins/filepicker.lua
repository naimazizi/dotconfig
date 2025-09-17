return {
  {
    "dmtrKovalenko/fff.nvim",
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    lazy = false,
    cond = not vim.g.vscode,
    config = function()
      vim.keymap.set("n", "<leader><space>", function()
        require("fff").find_files()
      end, { noremap = true, desc = "Find Files (cwd)" })

      vim.keymap.set("n", "<leader>ff", function()
        require("fff").find_files()
      end, { noremap = true, desc = "Find Files (Root Dir)" })

      vim.keymap.set("n", "<leader>fF", function()
        require("fff").find_files()
      end, { noremap = true, desc = "Find Files (cwd)" })

      vim.keymap.set("n", "<leader>fg", function()
        require("fff").find_in_git_root()
      end, { noremap = true, desc = "Find Files (git-files)" })

      require("fff").setup({
        -- Core settings
        base_path = vim.fn.getcwd(), -- Base directory for file indexing
        max_results = 100, -- Maximum search results to display
        max_threads = 4, -- Maximum threads for fuzzy search
        prompt = "󰱼 ", -- Input prompt symbol
        title = "FFF Files", -- Window title

        -- Keymaps
        keymaps = {
          close = "<Esc>",
          select = "<CR>",
          select_split = "<C-s>",
          select_vsplit = "<C-v>",
          select_tab = "<C-t>",
          move_up = { "<Up>", "<C-p>" }, -- Multiple bindings supported
          move_down = { "<Down>", "<C-n>" },
          preview_scroll_up = "<C-u>",
          preview_scroll_down = "<C-d>",
          toggle_debug = "<F2>", -- Toggle debug scores display
        },
      })
    end,
  },
}
