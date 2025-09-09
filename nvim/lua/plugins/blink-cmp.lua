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
      {
        "fang2hou/blink-copilot",
        opts = {
          max_completions = 2,
        },
      },
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
          -- Fix multiline ghost_text overlapping the cmp menu
          direction_priority = function()
            local ctx = require("blink.cmp").get_context()
            local item = require("blink.cmp").get_selected_item()
            if ctx == nil or item == nil then
              return { "s", "n" }
            end

            local item_text = item.textEdit ~= nil and item.textEdit.newText or item.insertText or item.label
            local is_multi_line = item_text:find("\n") ~= nil

            -- after showing the menu upwards, we want to maintain that direction
            -- until we re-open the menu, so store the context id in a global variable
            if is_multi_line or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
              vim.g.blink_cmp_upwards_ctx_id = ctx.id
              return { "n", "s" }
            end
            return { "s", "n" }
          end,
          draw = {
            padding = { 0, 1 },
            columns = { { "kind_icon" }, { "label", gap = 1 } },
            components = {
              kind_icon = {
                text = function(ctx)
                  local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                  return " " .. kind_icon .. ctx.icon_gap .. " "
                end,
                -- (optional) use highlights from mini.icons
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
              kind = {
                -- (optional) use highlights from mini.icons
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
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
  {
    "xzbdmw/colorful-menu.nvim",
    event = "VimEnter",
    cond = not vim.g.vscode,
    config = function()
      require("colorful-menu").setup({
        ls = {
          lua_ls = {
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
            -- instead of go's original syntax "foo Foo". If align_type_to_right is
            -- true, this option has no effect.
            add_colon_before_type = false,
            -- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
            preserve_type_when_truncate = true,
          },
          -- for lsp_config or typescript-tools
          ts_ls = {
            -- false means do not include any extra info,
            -- see https://github.com/xzbdmw/colorful-menu.nvim/issues/42
            extra_info_hl = "@comment",
          },
          vtsls = {
            -- false means do not include any extra info,
            -- see https://github.com/xzbdmw/colorful-menu.nvim/issues/42
            extra_info_hl = "@comment",
          },
          ["rust-analyzer"] = {
            -- Such as (as Iterator), (use std::io).
            extra_info_hl = "@comment",
            -- Similar to the same setting of gopls.
            align_type_to_right = true,
            -- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
            preserve_type_when_truncate = true,
          },
          clangd = {
            -- Such as "From <stdio.h>".
            extra_info_hl = "@comment",
            -- Similar to the same setting of gopls.
            align_type_to_right = true,
            -- the hl group of leading dot of "•std::filesystem::permissions(..)"
            import_dot_hl = "@comment",
            -- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
            preserve_type_when_truncate = true,
          },
          zls = {
            -- Similar to the same setting of gopls.
            align_type_to_right = true,
          },
          roslyn = {
            extra_info_hl = "@comment",
          },
          dartls = {
            extra_info_hl = "@comment",
          },
          -- The same applies to pyright/pylance
          basedpyright = {
            -- It is usually import path such as "os"
            extra_info_hl = "@comment",
          },
          pylsp = {
            extra_info_hl = "@comment",
            -- Dim the function argument area, which is the main
            -- difference with pyright.
            arguments_hl = "@comment",
          },
          -- If true, try to highlight "not supported" languages.
          fallback = true,
          -- this will be applied to label description for unsupport languages
          fallback_extra_info_hl = "@comment",
        },
        -- If the built-in logic fails to find a suitable highlight group for a label,
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
}
