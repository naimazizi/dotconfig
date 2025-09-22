return {
  {
    "hiphish/rainbow-delimiters.nvim",
    vscode = false,
    event = "BufRead",
  },
  {
    "chrisgrieser/nvim-origami",
    vscode = false,
    event = "BufRead",
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
  {
    "chrisgrieser/nvim-various-textobjs",
    event = "VeryLazy",
    opts = {
      keymaps = {
        useDefaults = true,
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    vscode = false,
    event = "BufRead",
    config = function()
      require("treesitter-context").setup({
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        multiwindow = false, -- Enable multiwindow support.
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 20, -- Maximum number of lines to show for a single context
        trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = "-",
        zindex = 20, -- The Z-index of the context window
        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
      })
    end,
  },
  {
    "sQVe/sort.nvim",
    vscode = true,
    event = "BufWrite",
    config = function()
      require("sort").setup({})
    end,
  },
  {
    "jake-stewart/multicursor.nvim",
    vscode = true,
    event = "BufEnter",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      local set = vim.keymap.set

      -- Add or skip cursor above/below the main cursor.
      set({ "n", "x" }, "<localleader>j", function()
        mc.lineAddCursor(1)
      end, { desc = "MultiCursor: Add cursor below" })
      set({ "n", "x" }, "<localleader>k", function()
        mc.lineAddCursor(-1)
      end, { desc = "MultiCursor: Add cursor above" })

      -- Add or skip adding a new cursor by matching word/selection
      set({ "n", "x" }, "<localleader>n", function()
        mc.matchAddCursor(1)
      end, { desc = "MultiCursor: Add cursor by matching word" })
      set({ "n", "x" }, "<localleader>x", function()
        mc.matchSkipCursor(1)
      end, { desc = "MultiCursor: Skip cursor by matching word" })
      set({ "n", "x" }, "<localleader>N", function()
        mc.matchAddCursor(-1)
      end, { desc = "MultiCursor: Add cursor by matching word (backwards)" })
      set({ "n", "x" }, "<localleader>X", function()
        mc.matchSkipCursor(-1)
      end, { desc = "MultiCursor: Skip cursor by matching word (backwards)" })

      -- Add and remove cursors with control + left click.
      set("n", "<c-leftmouse>", mc.handleMouse)
      set("n", "<c-leftdrag>", mc.handleMouseDrag)
      set("n", "<c-leftrelease>", mc.handleMouseRelease)

      -- Disable and enable cursors.
      set({ "n", "x" }, "<localleader>q", mc.toggleCursor, { desc = "MultiCursor: Toggle cursor" })

      -- Mappings defined in a keymap layer only apply when there are
      -- multiple cursors. This lets you have overlapping mappings.
      mc.addKeymapLayer(function(layerSet)
        -- Select a different cursor as the main one.
        layerSet({ "n", "x" }, "<left>", mc.prevCursor)
        layerSet({ "n", "x" }, "<right>", mc.nextCursor)

        -- Delete the main cursor.
        layerSet({ "n", "x" }, "<localleader>x", mc.deleteCursor, { desc = "MultiCursor: Delete cursor" })

        -- Enable and clear cursors using escape.
        layerSet("n", "<esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)

      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { reverse = true })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorMatchPreview", { link = "Search" })
      hl(0, "MultiCursorDisabledCursor", { reverse = true })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end,
  },
  {
    "zaucy/mcos.nvim",
    vscode = true,
    event = "BufEnter",
    dependencies = {
      "jake-stewart/multicursor.nvim",
    },
    config = function()
      local mcos = require("mcos")
      mcos.setup({})

      vim.keymap.set(
        { "n", "v" },
        "gM",
        mcos.opkeymapfunc,
        { expr = true, desc = "MultiCursor: add cursors in selection" }
      )
      vim.keymap.set({ "n" }, "gMM", mcos.bufkeymapfunc, { desc = "MultiCursor: add cursor in buffer" })
    end,
  },
  {
    "andymass/vim-matchup",
    vscode = true,
    event = "BufRead",
    init = function()
      ---@diagnostic disable-next-line: param-type-not-match
      require("match-up").setup({
        treesitter = {
          stopline = 500,
        },
      })
    end,
  },
}
