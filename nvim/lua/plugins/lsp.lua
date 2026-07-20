local function lsp_attach(bufnr)
  -- Set LSP keymaps via pick utils
  require("utils.pick").lsp_keymaps(bufnr)

  -- CodeLens
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  local supports_codelens = false
  for _, client in ipairs(clients) do
    if client:supports_method("textDocument/codeLens") then
      supports_codelens = true
      break
    end
  end

  if supports_codelens then
    -- vim.lsp.codelens.enable()
  end

  -- Inlay hints (conditionally enabled; not all servers support it)
  local supports_inlay_hints = false
  for _, client in ipairs(clients) do
    if client:supports_method("textDocument/inlayHint") then
      supports_inlay_hints = true
      break
    end
  end

  if supports_inlay_hints then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "saghen/blink.cmp",
    },
    vscode = false,
    opts = {
      servers = {},
    },
    config = function()
      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = " ",
          },
        },
        virtual_text = false,
      })

      -- Lua
      vim.lsp.config("emmylua_ls", {
        cmd = { "emmylua_ls" },
        filetypes = { "lua" },
        root_markers = { ".emmyrc.json", ".luarc.json", ".git" },
        settings = {
          runtime = {
            version = "LuaJIT",
          },
        },
      })

      -- Markdown
      vim.lsp.config("panache", {})

      -- Python
      vim.lsp.config("pyrefly", {})
      vim.lsp.config("ruff", {})

      -- Rust
      vim.lsp.config("bacon_ls", {
        init_options = {
          updateOnSave = true,
          updateOnSaveWaitMillis = 1000,
        },
      })

      -- Typos
      vim.lsp.config("typos_lsp", {
        init_options = {
          diagnosticSeverity = "Hint",
        },
      })

      -- Typst
      vim.lsp.config("tinymist", {
        single_file_support = true, -- Fixes LSP attachment in non-Git directories
        settings = {
          formatterMode = "typstyle",
          semanticTokens = "enable",
        },
      })

      -- Harper
      vim.lsp.config("harper_ls", {
        filetypes = {
          "markdown",
          "gitcommit",
        },
        settings = {
          ["harper-ls"] = {
            userDictPath = "",
            fileDictPath = "",
            linters = {
              SpellCheck = true,
              SpelledNumbers = false,
              AnA = true,
              SentenceCapitalization = true,
              UnclosedQuotes = true,
              WrongQuotes = false,
              LongSentences = true,
              RepeatedWords = true,
              Spaces = true,
              Matcher = true,
              CorrectNumberSuffix = true,
            },
            codeActions = {
              ForceStable = false,
            },
            markdown = {
              IgnoreLinkTitle = true,
            },
            diagnosticSeverity = "hint",
            isolateEnglish = false,
            dialect = "British",
          },
        },
      })

      -- Yaml
      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            schemas = {
              ["https://raw.githubusercontent.com/dbt-labs/dbt-jsonschema/main/schemas/latest/dbt_yml_files-latest.json"] = {
                "/**/models/**/*.yml",
                "/**/seeds/**/*.yml",
                "/**/snapshots/**/*.yml",
                "/**/analyses/**/*.yml",
                "/**/macros/**/*.yml",
                "/**/tests/**/*.yml",
              },
              ["https://raw.githubusercontent.com/dbt-labs/dbt-jsonschema/main/schemas/latest/dbt_project-latest.json"] = "dbt_project.yml",
              ["https://raw.githubusercontent.com/dbt-labs/dbt-jsonschema/main/schemas/latest/selectors-latest.json"] = "selectors.yml",
              ["https://raw.githubusercontent.com/dbt-labs/dbt-jsonschema/main/schemas/latest/packages-latest.json"] = "packages.yml",
            },
          },
        },
      })

      -- Enabled LSP
      vim.lsp.enable({
        "jsonls",
        "emmylua_ls",
        "panache",
        "pyrefly",
        "ruff",
        "bacon_ls",
        "typos_lsp",
        "tinymist",
        "yamlls",
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          lsp_attach(args.buf)
        end,
      })
    end,
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    priority = 1000,
    opts = {
      preset = "modern",
      options = {
        show_source = {
          if_many = true,
        },
        multilines = {
          enabled = true,
          always_show = true,
          trim_whitespaces = true,
          tabstop = 4,
        },
        use_icons_from_diagnostic = true,
      },
    },
  },
  {
    "Wansmer/symbol-usage.nvim",
    event = "LspAttach",
    config = function()
      local function h(name)
        return vim.api.nvim_get_hl(0, { name = name })
      end

      -- hl-groups can have any name
      vim.api.nvim_set_hl(0, "SymbolUsageRounding", { fg = h("CursorLine").bg, italic = true })
      vim.api.nvim_set_hl(0, "SymbolUsageContent", { bg = h("CursorLine").bg, fg = h("Comment").fg, italic = true })
      vim.api.nvim_set_hl(0, "SymbolUsageRef", { fg = h("Function").fg, bg = h("CursorLine").bg, italic = true })
      vim.api.nvim_set_hl(0, "SymbolUsageDef", { fg = h("Type").fg, bg = h("CursorLine").bg, italic = true })
      vim.api.nvim_set_hl(0, "SymbolUsageImpl", { fg = h("@keyword").fg, bg = h("CursorLine").bg, italic = true })

      local function text_format(symbol)
        local res = {}

        local round_start = { "", "SymbolUsageRounding" }
        local round_end = { "", "SymbolUsageRounding" }

        -- Indicator that shows if there are any other symbols in the same line
        local stacked_functions_content = symbol.stacked_count > 0 and ("+%s"):format(symbol.stacked_count) or ""

        if symbol.references then
          local usage = symbol.references <= 1 and "usage" or "usages"
          local num = symbol.references == 0 and "no" or symbol.references
          table.insert(res, round_start)
          table.insert(res, { "󰌹 ", "SymbolUsageRef" })
          table.insert(res, { ("%s %s"):format(num, usage), "SymbolUsageContent" })
          table.insert(res, round_end)
        end

        if symbol.definition then
          if #res > 0 then
            table.insert(res, { " ", "NonText" })
          end
          table.insert(res, round_start)
          table.insert(res, { "󰳽 ", "SymbolUsageDef" })
          table.insert(res, { symbol.definition .. " defs", "SymbolUsageContent" })
          table.insert(res, round_end)
        end

        if symbol.implementation then
          if #res > 0 then
            table.insert(res, { " ", "NonText" })
          end
          table.insert(res, round_start)
          table.insert(res, { "󰡱 ", "SymbolUsageImpl" })
          table.insert(res, { symbol.implementation .. " impls", "SymbolUsageContent" })
          table.insert(res, round_end)
        end

        if stacked_functions_content ~= "" then
          if #res > 0 then
            table.insert(res, { " ", "NonText" })
          end
          table.insert(res, round_start)
          table.insert(res, { " ", "SymbolUsageImpl" })
          table.insert(res, { stacked_functions_content, "SymbolUsageContent" })
          table.insert(res, round_end)
        end

        return res
      end

      require("symbol-usage").setup({
        text_format = text_format,
      })
    end,
  },
}
