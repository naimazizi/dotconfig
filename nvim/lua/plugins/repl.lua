return {
  "matarina/pyrola.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  build = ":UpdateRemotePlugins",
  config = function(_, opts)
    local pyrola = require("pyrola")
    pyrola.setup({
      kernel_map = { -- Map Jupyter kernel names to Neovim filetypes
        python = "python3",
        r = "ir",
        cpp = "xcpp14",
      },
      split_horizen = false, -- Define the terminal split direction
      split_ratio = 0.3, -- Set the terminal split size
    })

    -- Define key mappings for enhanced functionality
    vim.keymap.set("n", "<localleader>rs", function()
      pyrola.send_statement_definition()
    end, { noremap = true, desc = "Send the current line to the REPL" })

    vim.keymap.set("v", "<localleader>rs", function()
      require("pyrola").send_visual_to_repl()
    end, { noremap = true, desc = "Send the visual selection to the REPL" })

    vim.keymap.set("n", "<localleader>ri", function()
      pyrola.inspect()
    end, { noremap = true, desc = "Inspect the current line in the REPL" })

    -- Configure Treesitter for enhanced code parsing
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "cpp", "r", "python" }, -- Ensure the necessary Treesitter language parsers are installed
      auto_install = true,
    })
  end,
}
