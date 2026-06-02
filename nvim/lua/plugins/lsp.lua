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
    vim.lsp.codelens.enable()
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
      })

      -- Markdown
      vim.lsp.config("marksman", {})

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

      -- Copilot
      vim.lsp.config("copilot", {})

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
                "/**/*.yml",
                "!profiles.yml",
                "!dbt_project.yml",
                "!packages.yml",
                "!selectors.yml",
                "!profile_template.yml",
                "!package-lock.yml",
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
        "marksman",
        "pyrefly",
        "ruff",
        "bacon_ls",
        "typos_lsp",
        "tinymist",
        "copilot",
        "harper_ls",
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
    config = function()
      require("tiny-inline-diagnostic").setup({
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
      })
    end,
  },
}
