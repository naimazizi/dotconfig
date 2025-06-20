return {
  {
    "jake-stewart/multicursor.nvim",
    event = "BufEnter",
    vscode = true,
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
      set({ "n", "x" }, "<localleader>s", function()
        mc.matchSkipCursor(1)
      end, { desc = "MultiCursor: Skip cursor by matching word" })
      set({ "n", "x" }, "<localleader>N", function()
        mc.matchAddCursor(-1)
      end, { desc = "MultiCursor: Add cursor by matching word (backwards)" })
      set({ "n", "x" }, "<localleader>S", function()
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
    event = "BufEnter",
    vscode = true,
    dependencies = {
      "jake-stewart/multicursor.nvim",
    },
    config = function()
      local mcos = require("mcos")
      mcos.setup({})

      vim.keymap.set(
        { "n", "v" },
        "gms",
        mcos.opkeymapfunc,
        { expr = true, desc = "MultiCursor: select all in buffer" }
      )
      vim.keymap.set({ "n" }, "gmss", mcos.bufkeymapfunc, { desc = "MultiCursor: select all in buffer" })
    end,
  },
}
