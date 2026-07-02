return {
  {
    "RRethy/vim-illuminate",
    vscode = false,
    event = "BufReadPost",
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
      end

      map("]]", "next")
      map("[[", "prev")

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
    keys = {
      { "]]", desc = "Next Reference" },
      { "[[", desc = "Prev Reference" },
    },
  },
  {
    "chrisgrieser/nvim-origami",
    vscode = false,
    event = "BufRead",
    opts = {
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
    },
    keys = {
      { "z1", "zM", desc = "Fold 1", noremap = true },
      { "z2", "zM1zr", desc = "Fold 2", noremap = true },
      { "z3", "zM2zr", desc = "Fold 3", noremap = true },
      { "z4", "zM3zr", desc = "Fold 4", noremap = true },
    },
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    vscode = false,
    event = "BufRead",
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
    opts = {
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
    },
  },
  {
    "sQVe/sort.nvim",
    vscode = true,
    cmd = { "Sort" },
    opts = {},
  },
  {
    "andymass/vim-matchup",
    vscode = false,
    event = "BufRead",
    main = "match-up",
    opts = {
      treesitter = {
        stopline = 500,
      },
    },
  },
  {
    "otavioschwanck/arrow.nvim",
    vscode = false,
    keys = {
      { ";", desc = "Arrow menu" },
      { "m", desc = "Arrow buffer" },
    },
    opts = {
      show_icons = true,
      leader_key = ";", -- Recommended to be a single key
      buffer_leader_key = "m", -- Per Buffer Mappings
    },
  },
  {
    "MagicDuck/grug-far.nvim",
    vscode = false,
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { "ast-grep" })
        end,
      },
    },
    keys = {
      {
        "<leader>sr",
        mode = { "n" },
        function()
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
        end,
        desc = "Search/Replace (grug-far)",
      },
      {
        "<leader>sr",
        mode = { "v" },
        function()
          local grug = require("grug-far")
          grug.toggle_instance({
            instanceName = "grugfar_within_instance",
            staticTitle = "Find and Replace",
            transient = true,
            visualSelectionUsage = "operate-within-range",
          })
        end,
        desc = "Search/Replace Within (grug-far)",
      },
    },
    opts = {
      showCompactInputs = true,
      showInputsTopPadding = true,
      showInputsBottomPadding = true,
    },
  },
  {
    "gregorias/coerce.nvim",
    vscode = false,
    dependencies = "gregorias/coop.nvim",
    keys = {
      { "co", "<Plug>(coerce-normal)", mode = "n", desc = "Coerce word" },
      { "go", "<Plug>(coerce-motion)", mode = "n", desc = "Coerce motion" },
      { "go", "<Plug>(coerce-visual)", mode = "x", desc = "Coerce selection" },
    },
    config = function()
      require("coerce").setup({})
      local wke = require("coerce.keymaps").which_key_expand
      require("which-key").add({
        { "co", group = "+Coerce word", expand = wke.normal_mode, mode = "n" },
        { "go", group = "+Coerce motion", expand = wke.motion_mode, mode = "n" },
        { "go", group = "+Coerce visual", expand = wke.visual_mode, mode = "x" },
      })
    end,
  },
  {
    "NMAC427/guess-indent.nvim",
    vscode = false,
    event = "BufRead",
    opts = {},
  },
  {
    "nemanjamalesija/smart-paste.nvim",
    vscode = false,
    event = "VeryLazy",
    config = true,
  },
}
