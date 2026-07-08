return {
  {
    "thesimonho/kanagawa-paper.nvim",
    enabled = true,
    vscode = false,
    lazy = false,
    priority = 1000,
    opts = function()
      local palette_colors = require("kanagawa-paper.colors").palette
      return {
        -- enable undercurls for underlined text
        undercurl = true,
        -- transparent background
        transparent = false,
        -- highlight background for the left gutter
        gutter = false,
        -- background for diagnostic virtual text
        diag_background = true,
        -- dim inactive windows. Disabled when transparent
        dim_inactive = false,
        -- set colors for terminal buffers
        terminal_colors = true,
        -- cache highlights and colors for faster startup.
        -- see Cache section for more details.
        cache = true,

        styles = {
          -- style for comments
          comment = { italic = true },
          -- style for functions
          functions = { italic = true },
          -- style for keywords
          keyword = { italic = false, bold = true },
          -- style for statements
          statement = { italic = false, bold = true },
          -- style for types
          type = { italic = true },
        },
        -- override default palette and theme colors
        colors = {
          palette = {},
          theme = {
            ink = {
              syn = {
                member = palette_colors.dragonYellow,
              },
            },
            canvas = {},
          },
        },
        -- adjust overall color balance for each theme [-1, 1]
        color_offset = {
          ink = { brightness = 0, saturation = 0 },
          canvas = { brightness = 0, saturation = 0 },
        },

        overrides = function(c)
          return {
            LspInlayHint = { fg = c.theme.syn.comment, bg = "NONE", italic = true },
            ["@string.documentation"] = { fg = c.theme.syn.comment, italic = true },
            ["@comment"] = { fg = c.theme.syn.comment, italic = true },
            -- DropBar UI
            DropBarMenuHoverEntry = { link = "Visual" },
            DropBarMenuHoverIcon = { reverse = true },
            DropBarMenuHoverSymbol = { bold = true },
            DropBarIconUISeparator = { fg = c.theme.ui.fg_dim },
            DropBarIconUISeparatorMenu = { fg = c.theme.ui.fg_dim },
            DropBarIconUISeparatorNC = { fg = c.theme.ui.fg_dimmer },
            DropBarIconUIIndicator = { fg = c.theme.ui.special },
            DropBarIconUIPickPivot = { fg = c.theme.ui.picker },
            -- DropBar kinds — functions / callables
            DropBarKindFunction = { fg = c.theme.syn.fun },
            DropBarKindMethod = { fg = c.theme.syn.fun },
            DropBarKindConstructor = { fg = c.theme.syn.fun },
            DropBarKindCall = { fg = c.theme.syn.fun },
            -- DropBar kinds — types
            DropBarKindClass = { fg = c.theme.syn.type },
            DropBarKindInterface = { fg = c.theme.syn.type },
            DropBarKindStruct = { fg = c.theme.syn.type },
            DropBarKindEnum = { fg = c.theme.syn.type },
            DropBarKindTypeParameter = { fg = c.theme.syn.type },
            DropBarKindType = { fg = c.theme.syn.type },
            DropBarKindUnit = { fg = c.theme.syn.type },
            -- DropBar kinds — members / fields
            DropBarKindField = { fg = c.theme.syn.member },
            DropBarKindProperty = { fg = c.theme.syn.member },
            DropBarKindEnumMember = { fg = c.theme.syn.member },
            -- DropBar kinds — constants / literals
            DropBarKindConstant = { fg = c.theme.syn.constant },
            DropBarKindBoolean = { fg = c.theme.syn.constant },
            DropBarKindNumber = { fg = c.theme.syn.number },
            DropBarKindNull = { fg = c.theme.syn.constant },
            DropBarKindValue = { fg = c.theme.syn.constant },
            -- DropBar kinds — variables / identifiers
            DropBarKindVariable = { fg = c.theme.syn.identifier },
            DropBarKindIdentifier = { fg = c.theme.syn.identifier },
            -- DropBar kinds — keywords / control flow
            DropBarKindKeyword = { fg = c.theme.syn.keyword },
            DropBarKindDeclaration = { fg = c.theme.syn.keyword },
            DropBarKindSpecifier = { fg = c.theme.syn.keyword },
            DropBarKindStatement = { fg = c.theme.syn.statement },
            DropBarKindIfStatement = { fg = c.theme.syn.statement },
            DropBarKindElseStatement = { fg = c.theme.syn.statement },
            DropBarKindForStatement = { fg = c.theme.syn.statement },
            DropBarKindWhileStatement = { fg = c.theme.syn.statement },
            DropBarKindDoStatement = { fg = c.theme.syn.statement },
            DropBarKindSwitchStatement = { fg = c.theme.syn.statement },
            DropBarKindCaseStatement = { fg = c.theme.syn.statement },
            DropBarKindBreakStatement = { fg = c.theme.syn.statement },
            DropBarKindContinueStatement = { fg = c.theme.syn.statement },
            DropBarKindReturnStatement = { fg = c.theme.syn.statement },
            DropBarKindGotoStatement = { fg = c.theme.syn.statement },
            -- DropBar kinds — strings / collections
            DropBarKindString = { fg = c.theme.syn.string },
            DropBarKindArray = { fg = c.theme.syn.string },
            DropBarKindList = { fg = c.theme.syn.string },
            -- DropBar kinds — operators / symbols
            DropBarKindOperator = { fg = c.theme.syn.operator },
            DropBarKindEvent = { fg = c.theme.syn.symbol },
            DropBarKindReference = { fg = c.theme.syn.symbol },
            -- DropBar kinds — macros / preprocessor
            DropBarKindMacro = { fg = c.theme.syn.special1 },
            DropBarKindRepeat = { fg = c.theme.syn.special1 },
            -- DropBar kinds — modules / namespaces
            DropBarKindModule = { fg = c.theme.syn.type },
            DropBarKindNamespace = { fg = c.theme.syn.type },
            DropBarKindPackage = { fg = c.theme.syn.type },
            -- DropBar kinds — filesystem / misc
            DropBarKindFile = { fg = c.theme.ui.special },
            DropBarKindFolder = { fg = c.theme.ui.special },
            DropBarKindScope = { fg = c.theme.ui.fg_dim },
            DropBarKindDelete = { fg = c.theme.syn.operator },
            DropBarKindObject = { fg = c.theme.ui.special },
            DropBarKindDefault = { fg = c.theme.ui.fg_dim },
            -- DropBar kinds — missing (added)
            DropBarKindBlockMappingPair = { fg = c.theme.ui.special },
            DropBarKindElement = { fg = c.theme.ui.special },
            DropBarKindPair = { fg = c.theme.ui.special },
            DropBarKindRule = { fg = c.theme.syn.special1 },
            DropBarKindRuleSet = { fg = c.theme.syn.special1 },
            DropBarKindSection = { fg = c.theme.ui.header1 },
            DropBarKindTable = { fg = c.theme.ui.special },
            DropBarKindTerminal = { fg = c.theme.ui.special },
            -- DropBar markdown headings
            DropBarKindMarkdownH1 = { fg = c.theme.ui.header1, bold = true },
            DropBarKindMarkdownH2 = { fg = c.theme.ui.header2, bold = true },
            DropBarKindMarkdownH3 = { fg = c.theme.syn.fun },
            DropBarKindMarkdownH4 = { fg = c.theme.syn.type },
            DropBarKindMarkdownH5 = { fg = c.theme.syn.string },
            DropBarKindMarkdownH6 = { fg = c.theme.syn.identifier },
          }
        end,

        -- uses lazy.nvim, if installed, to automatically enable needed plugins
        auto_plugins = true,
      }
    end,
    config = function(_, opts)
      require("kanagawa-paper").setup(opts)
      vim.cmd.colorscheme("kanagawa-paper")

      local kanagawa_paper = require("lualine.themes.kanagawa-paper-ink")
      require("lualine").setup({
        options = {
          theme = kanagawa_paper,
        },
      })
    end,
  },
}
