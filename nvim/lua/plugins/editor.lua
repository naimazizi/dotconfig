return {
  {
    "hiphish/rainbow-delimiters.nvim",
    event = "BufRead",
    vscode = false,
  },
  {
    "WilliamHsieh/overlook.nvim",
    event = "BufRead",
    vscode = false,
    keys = {
      {
        "go",
        function()
          require("overlook.api").peek_definition()
        end,
        desc = "Overlook: Peek definition",
      },
      {
        "gL",
        function()
          require("overlook.api").close_all()
        end,
        desc = "Overlook: Close all popup",
      },
      {
        "gl",
        function()
          require("overlook.api").restore_popup()
        end,
        desc = "Overlook: Restore popup",
      },
    },
  },
  {
    "chrisgrieser/nvim-origami",
    event = "BufRead",
    vscode = false,
    -- recommended: disable vim's auto-folding
    init = function()
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
    end,
    config = function()
      require("origami").setup({
        useLspFoldsWithTreesitterFallback = true, -- required for `autoFold`
        autoFold = {
          enabled = true,
          kinds = { "comment", "imports" }, ---@type lsp.FoldingRangeKind[]
        },
        foldtext = {
          enabled = true,
          lineCount = {
            template = "   %d lines", -- `%d` is replaced with the number of folded lines
            hlgroup = "Comment",
          },
          diagnostics = {
            enabled = true,
            -- uses hlgroups and icons from `vim.diagnostic.config().signs`
          },
        },
        pauseFoldsOnSearch = true,
        foldKeymaps = {
          setup = true, -- modifies `h` and `l`
          hOnlyOpensOnFirstColumn = false,
        },
      })
    end,
  },
  -- {
  --   "kevinhwang91/nvim-ufo",
  --   event = "BufRead",
  --   vscode = false,
  --   dependencies = { "kevinhwang91/promise-async" },
  --   config = function()
  --     vim.o.foldcolumn = "1" -- '0' is not bad
  --     vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
  --     vim.o.foldlevelstart = 99
  --     vim.o.foldenable = true
  --
  --     -- Option 3: treesitter as a main provider instead
  --     -- (Note: the `nvim-treesitter` plugin is *not* needed.)
  --     -- ufo uses the same query files for folding (queries/<lang>/folds.scm)
  --     -- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`
  --     require("ufo").setup({
  --       provider_selector = function(bufnr, filetype, buftype)
  --         return { "treesitter", "indent" }
  --       end,
  --     })
  --     --
  --   end,
  -- },
}
