return {
  {
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
  },
  {
    "benlubas/molten-nvim",
    event = "VeryLazy",
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_wrap_output = true
      vim.keymap.set(
        "n",
        "<localleader>mi",
        ":MoltenInit<CR>",
        { silent = true, desc = "Molten - Initialize the plugin" }
      )
      vim.keymap.set(
        "n",
        "<localleader>mw",
        ":MoltenEvaluateOperator<CR>",
        { silent = true, desc = "Molten - Run operator selection" }
      )
      vim.keymap.set(
        "n",
        "<localleader>me",
        ":MoltenEvaluateLine<CR>",
        { silent = true, desc = "Molten - Evaluate line" }
      )
      vim.keymap.set(
        "n",
        "<localleader>mr",
        ":MoltenReevaluateCell<CR>",
        { silent = true, desc = "Molten - Re-evaluate cell" }
      )
      vim.keymap.set(
        "v",
        "<localleader>me",
        ":<C-u>MoltenEvaluateVisual<CR>gv",
        { silent = true, desc = "Molten - Evaluate visual selection" }
      )
      vim.keymap.set("n", "<localleader>md", ":MoltenDelete<CR>", { silent = true, desc = "Molten - Delete cell" })
      vim.keymap.set("n", "<localleader>mh", ":MoltenHideOutput<CR>", { silent = true, desc = "Molten - Hide output" })
      vim.keymap.set(
        "n",
        "<localleader>ms",
        ":noautocmd MoltenEnterOutput<CR>",
        { silent = true, desc = "Molten - Show/enter output" }
      )
      vim.keymap.set(
        "n",
        "<localleader>mn",
        ":noautocmd MoltenNext<CR>",
        { silent = true, desc = "Molten - Go to Next Cell" }
      )
      vim.keymap.set(
        "n",
        "<localleader>mN",
        ":noautocmd MoltenNext<CR>",
        { silent = true, desc = "Molten - Go to Previous Cell" }
      )
    end,
  },
}
