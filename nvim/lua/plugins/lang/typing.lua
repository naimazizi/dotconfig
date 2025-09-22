---@diagnostic disable: inject-field
vim.lsp.enable({ "harper_ls", "typos_lsp" })

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        typos_lsp = {
          -- Logging level of the language server. Logs appear in :LspLog. Defaults to error.
          cmd_env = { RUST_LOG = "error" },
          init_options = {
            -- Custom config. Used together with a config file found in the workspace or its parents,
            -- taking precedence for settings declared in both.
            -- Equivalent to the typos `--config` cli argument.
            config = "~/code/typos-lsp/crates/typos-lsp/tests/typos.toml",
            -- How typos are rendered in the editor, can be one of an Error, Warning, Info or Hint.
            -- Defaults to error.
            diagnosticSeverity = "Hint",
          },
        },
        harper_ls = {
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
        },
      },
    },
  },
}
