return {
  {
    "saghen/blink.compat",
    -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
    version = "*",
    -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
    lazy = true,
    -- make sure to set opts so that lazy.nvim calls blink.compat's setup
    opts = {},
  },
  {
    "saghen/blink.cmp",
    version = not vim.g.lazyvim_blink_main and "*",
    build = vim.g.lazyvim_blink_main and "cargo build --release",
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.compat",
      "sources.default",
    },
    dependencies = {
      "rafamadriz/friendly-snippets",
      -- add blink.compat to dependencies
      {
        "saghen/blink.compat",
        optional = true, -- make optional so it's only enabled if any extras need it
        opts = {},
        version = not vim.g.lazyvim_blink_main and "*",
      },
      "jmbuhr/cmp-pandoc-references",
      "xzbdmw/colorful-menu.nvim",
      "fang2hou/blink-copilot",
      "copilotlsp-nvim/copilot-lsp",
      "yetone/avante.nvim",
      "Kaiser-Yang/blink-cmp-avante",
      {
        "MattiasMTS/cmp-dbee",
        ft = "sql",
        dependencies = {
          { "kndndrj/nvim-dbee" },
        },
      },
    },
    event = "InsertEnter",
    opts = {
      snippets = {
        expand = function(snippet, _)
          return LazyVim.cmp.expand(snippet)
        end,
      },
      appearance = {
        -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },
      completion = {
        accept = {
          -- experimental auto-brackets support
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
            columns = { { "kind_icon" }, { "label", gap = 1 } },
            components = {
              label = {
                text = function(ctx)
                  return require("colorful-menu").blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require("colorful-menu").blink_components_highlight(ctx)
                end,
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = {
          enabled = vim.g.ai_cmp,
        },
        trigger = {
          show_on_trigger_character = true,
          show_on_blocked_trigger_characters = { " ", "\n", "\t" },
          show_in_snippet = true,
        },
      },

      fuzzy = {
        implementation = "rust",
        sorts = {
          "exact",
          -- defaults
          "score",
          "sort_text",
        },
      },
      -- experimental signature help support
      signature = { enabled = false, trigger = { show_on_accept = true } },

      sources = {
        -- adding any nvim-cmp sources here will enable them
        -- with blink.compat
        compat = {},

        default = {
          "lsp",
          "path",
          "snippets",
          "buffer",
          "references",
          "path",
          "copilot",
          "avante",
          "dbee",
        },
        per_filetype = {
          sql = { "dbee", "buffer" }, -- Add any other source to include here
        },
        providers = {
          references = {
            name = "pandoc_references",
            module = "cmp-pandoc-references.blink",
          },
          path = {
            opts = {
              get_cwd = function(_)
                return vim.fn.getcwd()
              end,
            },
          },
          copilot = {
            name = "copilot",
            module = "blink-copilot",
          },
          avante = {
            module = "blink-cmp-avante",
            name = "Avante",
            opts = {},
          },
          dbee = { name = "cmp-dbee", module = "blink.compat.source" },
        },
      },

      cmdline = {
        enabled = false,
      },

      keymap = {
        preset = "super-tab",
        ["<Tab>"] = {
          function(cmp)
            if vim.b[vim.api.nvim_get_current_buf()].nes_state then
              cmp.hide()
              return (
                require("copilot-lsp.nes").apply_pending_nes()
                and require("copilot-lsp.nes").walk_cursor_end_edit()
              )
            end
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          "snippet_forward",
          "fallback",
        },
      },
    },
  },
  {
    "xzbdmw/colorful-menu.nvim",
    event = "LspAttach",
    config = function()
      -- You don't need to set these options.
      require("colorful-menu").setup({
        ls = {
          lua_ls = {
            -- Maybe you want to dim arguments a bit.
            arguments_hl = "@comment",
          },
          gopls = {
            -- By default, we render variable/function's type in the right most side,
            -- to make them not to crowd together with the original label.

            -- when true:
            -- foo             *Foo
            -- ast         "go/ast"

            -- when false:
            -- foo *Foo
            -- ast "go/ast"
            align_type_to_right = true,
            -- When true, label for field and variable will format like "foo: Foo"
            -- instead of go's original syntax "foo Foo".
            add_colon_before_type = false,
          },
          -- for lsp_config or typescript-tools
          ts_ls = {
            extra_info_hl = "@comment",
          },
          vtsls = {
            extra_info_hl = "@comment",
          },
          ["rust-analyzer"] = {
            -- Such as (as Iterator), (use std::io).
            extra_info_hl = "@comment",
          },
          clangd = {
            -- Such as "From <stdio.h>".
            extra_info_hl = "@comment",
          },
          roslyn = {
            extra_info_hl = "@comment",
          },
          -- The same applies to pyright/pylance
          pyright = {
            -- It is usually import path such as "os"
            extra_info_hl = "@comment",
          },
          basedpyright = {
            -- It is usually import path such as "os"
            extra_info_hl = "@comment",
          },

          -- If true, try to highlight "not supported" languages.
          fallback = true,
        },
        -- If the built-in logic fails to find a suitable highlight group,
        -- this highlight is applied to the label.
        fallback_highlight = "@variable",
        -- If provided, the plugin truncates the final displayed text to
        -- this width (measured in display cells). Any highlights that extend
        -- beyond the truncation point are ignored. When set to a float
        -- between 0 and 1, it'll be treated as percentage of the width of
        -- the window: math.floor(max_width * vim.api.nvim_win_get_width(0))
        -- Default 60.
        max_width = 60,
      })
    end,
  },
  {
    "nvim-lspconfig",
    opts = function(_, opts)
      opts.diagnostics = {
        virtual_text = false,
      }
      opts.servers.harper_ls = {
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
              IgnoreLinkTitle = false,
            },
            diagnosticSeverity = "hint",
            isolateEnglish = false,
            dialect = "British",
          },
        },
      }
    end,
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    priority = 1000, -- needs to be loaded in first
    config = function()
      require("tiny-inline-diagnostic").setup({
        preset = "modern",
        show_source = true,
        options = {
          softwrap = 60,
          use_icons_from_diagnostic = true,
          virt_texts = {
            priority = 4096,
          },
          multilines = {
            enabled = true,
            always_show = false,
          },
          break_line = {
            -- Enable the feature to break messages after a specific length
            enabled = true,

            -- Number of characters after which to break the line
            after = 30,
          },
        },
      })
    end,
  },
}
