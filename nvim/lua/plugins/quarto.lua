return {
  { -- requires plugins in lua/plugins/treesitter.lua and lua/plugins/lsp.lua
    -- for complete functionality (language features)
    "quarto-dev/quarto-nvim",
    vscode = false,
    config = function()
      require("quarto").setup({
        debug = false,
        closePreviewOnExit = true,
        lspFeatures = {
          enabled = true,
          chunks = "curly",
          languages = { "r", "python", "julia" },
          diagnostics = {
            enabled = true,
            triggers = { "BufWritePost" },
          },
          completion = {
            enabled = true,
          },
        },
        codeRunner = {
          enabled = true,
          default_method = "slime", -- "molten", "slime", "iron" or <function>
        },
      })
      local runner = require("quarto.runner")
      vim.keymap.set("n", "<localleader>ss", runner.run_cell, { desc = "run cell", silent = true })
      vim.keymap.set("n", "<localleader>sa", runner.run_above, { desc = "run cell and above", silent = true })
      vim.keymap.set("n", "<localleader>sA", runner.run_all, { desc = "run all cells", silent = true })
      vim.keymap.set("n", "<localleader>se", runner.run_line, { desc = "run line", silent = true })
      vim.keymap.set("v", "<localleader>ss", runner.run_range, { desc = "run visual range", silent = true })
      vim.keymap.set("n", "<localleader>sf", function()
        runner.run_all(true)
      end, { desc = "run all cells of all languages", silent = true })

      require("which-key").add({
        { "<localleader>s", desc = "Quarto (REPL)", icon = " " },
      })
    end,

    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
      "MeanderingProgrammer/render-markdown.nvim",
    },
  },
  { -- directly open ipynb files as quarto documents
    -- and convert back behind the scenes
    "GCBallesteros/jupytext.nvim",
    vscode = false,
    event = "BufRead *.ipynb",
    opts = {
      custom_language_formatting = {
        python = {
          extension = "qmd",
          style = "quarto",
          force_ft = "quarto",
        },
        r = {
          extension = "qmd",
          style = "quarto",
          force_ft = "quarto",
        },
      },
    },
  },
}
