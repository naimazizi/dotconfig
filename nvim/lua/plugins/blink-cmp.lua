return {
  { -- Autocompletion
    "saghen/blink.cmp",
    cond = not vim.g.vscode,
    event = "VimEnter",
    version = "1.*",
    dependencies = {
      -- Snippet Engine
      {
        "L3MON4D3/LuaSnip",
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
        dependencies = {
          {
            "rafamadriz/friendly-snippets",
            config = function()
              require("luasnip.loaders.from_vscode").lazy_load()
            end,
          },
        },
        opts = {},
      },
      "folke/lazydev.nvim",
      "jmbuhr/cmp-pandoc-references",
      "fang2hou/blink-copilot",
      "yetone/avante.nvim",
      "Kaiser-Yang/blink-cmp-avante",
      "t3ntxcl3s/ecolog.nvim",
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {

      snippets = { preset = "luasnip" },

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
        list = {
          selection = {
            preselect = function()
              return not require("blink.cmp").snippet_active({ direction = 1 })
            end,
          },
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

        default = {
          "lsp",
          "path",
          "snippets",
          "buffer",
          "references",
          "path",
          "copilot",
          "avante",
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
          ecolog = { name = "ecolog", module = "ecolog.integrations.cmp.blink_cmp" },
        },
      },

      cmdline = {
        enabled = true,
      },

      term = {
        enabled = true,
        keymap = { preset = "inherit" },
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
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
      },
    },
  },
}
