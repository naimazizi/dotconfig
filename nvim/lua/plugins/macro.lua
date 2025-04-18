return {
  {
    "chrisgrieser/nvim-recorder",
    event = "VeryLazy",
    keys = {
      -- these must match the keys in the mapping config below
      { "q", desc = " Start Recording" },
      { "Q", desc = " Play Recording" },
      { "<C-q>", desc = " Switch Slot" },
      { "cq", desc = " Edit Recording" },
      { "dq", desc = " Delete All Recordings" },
      { "yq", desc = " Yank Recording" },
      { "##", desc = " Add Breakpoint" },
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("recorder").setup({
        -- Named registers where macros are saved (single lowercase letters only).
        -- The first register is the default register used as macro-slot after
        -- startup.
        slots = { "a", "b" },

        -- specify one of options:
        -- [static]   -> use static slots, this is default behaviour
        -- [rotate]   -> rotates through letters specified in slots[]
        dynamicSlots = "static",

        mapping = {
          startStopRecording = "q",
          playMacro = "Q",
          switchSlot = "<C-q>",
          editMacro = "cq",
          deleteAllMacros = "dq",
          yankMacro = "yq",
          addBreakPoint = "##",
        },

        -- Clears all macros-slots on startup.
        clear = false,

        -- Log level used for non-critical notifications; mostly relevant for nvim-notify.
        -- (Note that by default, nvim-notify does not show the levels `trace` & `debug`.)
        logLevel = vim.log.levels.INFO, -- :help vim.log.levels

        -- If enabled, only essential notifications are sent.
        -- If you do not use a plugin like nvim-notify, set this to `true`
        -- to remove otherwise annoying messages.
        lessNotifications = false,

        -- Use nerdfont icons in the status bar components and keymap descriptions
        useNerdfontIcons = true,

        -- Performance optimizations for macros with high count. When `playMacro` is
        -- triggered with a count higher than the threshold, nvim-recorder
        -- temporarily changes changes some settings for the duration of the macro.
        performanceOpts = {
          countThreshold = 100,
          lazyredraw = true, -- enable lazyredraw (see `:h lazyredraw`)
          noSystemClipboard = true, -- remove `+`/`*` from clipboard option
          autocmdEventsIgnore = { -- temporarily ignore these autocmd events
            "TextChangedI",
            "TextChanged",
            "InsertLeave",
            "InsertEnter",
            "InsertCharPre",
          },
        },

        -- [experimental] partially share keymaps with nvim-dap.
        -- (See README for further explanations.)
        dapSharedKeymaps = false,
      })
    end,
  },
}
