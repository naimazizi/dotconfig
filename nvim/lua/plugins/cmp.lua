return {
  {
    "saghen/blink.compat",
    -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
    version = "*",
    -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
    lazy = true,
    vscode = false,
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
      "yetone/avante.nvim",
      "Kaiser-Yang/blink-cmp-avante",
      "t3ntxcl3s/ecolog.nvim",
      {
        "MattiasMTS/cmp-dbee",
        ft = "sql",
        dependencies = {
          { "kndndrj/nvim-dbee" },
        },
      },
      { "L3MON4D3/LuaSnip" },
    },
    event = "InsertEnter",
    vscode = false,
    opts = {
      snippets = {
        preset = "luasnip",
        expand = function(snippet, _)
          return require("luasnip").lsp_expand(snippet)
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
          enabled = true,
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
          "ecolog",
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
            score_offset = 100,
            async = true,
            opts = {
              max_completions = 3, -- Override global max_completions
            },
          },
          avante = {
            module = "blink-cmp-avante",
            name = "Avante",
            opts = {},
          },
          dbee = { name = "cmp-dbee", module = "blink.compat.source" },
          ecolog = { name = "ecolog", module = "ecolog.integrations.cmp.blink_cmp" },
        },
      },

      cmdline = {
        enabled = false,
      },

      keymap = {
        preset = "super-tab",
        ["<Tab>"] = {
          function(cmp)
            if vim.g.copilot_nes_enabled == true then
              if vim.b[vim.api.nvim_get_current_buf()].nes_state then
                cmp.hide()
                return (
                  require("copilot-lsp.nes").apply_pending_nes()
                  and require("copilot-lsp.nes").walk_cursor_end_edit()
                )
              end
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
}
