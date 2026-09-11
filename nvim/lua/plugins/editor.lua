vim.pack.add({
  Config.gh("RRethy/vim-illuminate"),
  Config.gh("chrisgrieser/nvim-origami"),
  Config.gh("chrisgrieser/nvim-various-textobjs"),
  Config.gh("sQVe/sort.nvim"),
  Config.gh("andymass/vim-matchup"),
  Config.gh("otavioschwanck/arrow.nvim"),
  Config.gh("MagicDuck/grug-far.nvim"),
  Config.gh("NMAC427/guess-indent.nvim"),
  Config.gh("nemanjamalesija/smart-paste.nvim"),
})

Config.on_event("BufReadPost", function()
  require("illuminate").configure({
    delay = 200,
    large_file_cutoff = 2000,
    large_file_overrides = {
      providers = { "lsp" },
    },
  })

  local function illuminate_map(key, dir, buffer)
    vim.keymap.set("n", key, function()
      require("illuminate")["goto_" .. dir .. "_reference"](false)
    end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
  end

  illuminate_map("]]", "next")
  illuminate_map("[[", "prev")

  -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
  vim.api.nvim_create_autocmd("FileType", {
    callback = function()
      local buffer = vim.api.nvim_get_current_buf()
      illuminate_map("]]", "next", buffer)
      illuminate_map("[[", "prev", buffer)
    end,
  })
end)

Config.on_event("BufRead", function()
  require("various-textobjs").setup({
    keymaps = {
      useDefaults = true,
    },
  })
end)

Config.later(function()
  require("sort").setup({})
end)

Config.on_event("BufRead", function()
  require("guess-indent").setup({})
end)

Config.later(function()
  require("smart-paste").setup({})
end)

if not vim.g.vscode then
  Config.on_event("BufRead", function()
    require("origami").setup({
      useLspFoldsWithTreesitterFallback = {
        enabled = true,
        foldmethodIfNeitherIsAvailable = "indent", ---@type string|fun(bufnr: number): string
      },
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
        hOnlyOpensOnFirstColumn = true,
      },
    })

    vim.keymap.set("n", "z1", "zM", { desc = "Fold 1", noremap = true })
    vim.keymap.set("n", "z2", "zM1zr", { desc = "Fold 2", noremap = true })
    vim.keymap.set("n", "z3", "zM2zr", { desc = "Fold 3", noremap = true })
    vim.keymap.set("n", "z4", "zM3zr", { desc = "Fold 4", noremap = true })
  end)

  Config.on_event("BufRead", function()
    vim.g.matchup_matchparen_offscreen = {}
    require("match-up").setup({
      treesitter = {
        stopline = 500,
      },
    })
  end)

  Config.later(function()
    require("arrow").setup({
      show_icons = true,
      leader_key = ";", -- Recommended to be a single key
      buffer_leader_key = "m", -- Per Buffer Mappings
    })
  end)

  Config.later(function()
    require("grug-far").setup({
      showCompactInputs = true,
      showInputsTopPadding = true,
      showInputsBottomPadding = true,
    })

    vim.keymap.set("n", "<leader>fr", function()
      local grug = require("grug-far")
      local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
      grug.toggle_instance({
        instanceName = "grugfar_instance",
        staticTitle = "Find and Replace",
        transient = true,
        prefills = {
          filesFilter = ext and ext ~= "" and "*." .. ext or nil,
        },
      })
    end, { desc = "Search/Replace (grug-far)" })

    vim.keymap.set("v", "<leader>sr", function()
      local grug = require("grug-far")
      grug.toggle_instance({
        instanceName = "grugfar_within_instance",
        staticTitle = "Find and Replace",
        transient = true,
        visualSelectionUsage = "operate-within-range",
      })
    end, { desc = "Search/Replace Within (grug-far)" })
  end)
end
