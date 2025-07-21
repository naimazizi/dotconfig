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
        use_nvim_cmp_as_default = false,
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
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = {
          enabled = vim.g.ai_cmp,
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
      signature = { enabled = true, trigger = { show_on_accept = true } },

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
        enabled = true,
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
      config = function(_, opts)
        -- Unset custom prop to pass blink.cmp validation
        opts.sources.compat = nil

        -- check if we need to override symbol kinds
        for _, provider in pairs(opts.sources.providers or {}) do
          ---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
          if provider.kind then
            local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
            local kind_idx = #CompletionItemKind + 1

            CompletionItemKind[kind_idx] = provider.kind
            ---@diagnostic disable-next-line: no-unknown
            CompletionItemKind[provider.kind] = kind_idx

            ---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
            local transform_items = provider.transform_items
            ---@param ctx blink.cmp.Context
            ---@param items blink.cmp.CompletionItem[]
            provider.transform_items = function(ctx, items)
              items = transform_items and transform_items(ctx, items) or items
              for _, item in ipairs(items) do
                item.kind = kind_idx or item.kind
                item.kind_icon = LazyVim.config.icons.kinds[item.kind_name] or item.kind_icon or nil
              end
              return items
            end

            -- Unset custom prop to pass blink.cmp validation
            provider.kind = nil
          end
        end

        require("blink.cmp").setup(opts)
      end,
    },
  },
}
