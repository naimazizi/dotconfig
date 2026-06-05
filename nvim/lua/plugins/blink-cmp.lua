return {
  { -- Autocompletion
    "saghen/blink.cmp",
    vscode = false,
    event = "InsertEnter",
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
              local snippets_path = vim.fn.stdpath("config") .. "/snippets"
              if vim.fn.isdirectory(snippets_path) == 1 then
                require("luasnip.loaders.from_vscode").lazy_load({ paths = { snippets_path } })
              end
            end,
          },
        },
        opts = {
          history = true,
          delete_check_events = "TextChanged",
        },
      },
      {
        "saghen/blink.compat",
        version = "*",
        lazy = true,
        opts = {},
      },
      "jmbuhr/cmp-pandoc-references",
      {
        "fang2hou/blink-copilot",
        opts = {
          max_completions = 2,
          kind_name = "Copilot", ---@type string | false
          kind_icon = " ", ---@type string | false
        },
      },
      "mayromr/blink-cmp-dap",
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = function()
      -- Local state for tracking completion menu direction across keystrokes.
      -- Using a local variable avoids repeated vim.g reads/writes on every keypress.
      local blink_cmp_upwards_ctx_id = nil

      return {
        enabled = function()
          return (vim.bo.buftype ~= "prompt" or vim.bo.filetype == "dap-repl") and vim.b.completion ~= false
        end,

        snippets = {
          preset = "luasnip",
          expand = function(snippet)
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
              if is_multi_line or blink_cmp_upwards_ctx_id == ctx.id then
                blink_cmp_upwards_ctx_id = ctx.id
                return { "n", "s" }
              end
              return { "s", "n" }
            end,
            border = "rounded",
          },
          documentation = {
            auto_show = true,
            window = { border = "rounded" },
          },
          ghost_text = {
            enabled = true,
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
        signature = { enabled = true, trigger = { show_on_accept = true }, window = { border = "rounded" } },

        sources = {
          default = {
            "lsp",
            "snippets",
            "buffer",
            "references",
            "copilot",
          },
          per_filetype = {
            ["dap-repl"] = { "dap" },
          },
          providers = {
            references = {
              name = "pandoc_references",
              module = "cmp-pandoc-references.blink",
            },
            copilot = {
              name = "copilot",
              module = "blink-copilot",
              score_offset = 100,
              async = true,
            },
            dap = {
              name = "dap",
              module = "blink-cmp-dap",
            },
            minuet = {
              name = "minuet",
              module = "minuet.blink",
              score_offset = 100,
              async = true,
              timeout_ms = 3000,
            },
          },
        },

        cmdline = {
          enabled = true,
        },

        term = {
          enabled = false,
          keymap = { preset = "inherit" },
        },

        keymap = {
          preset = "super-tab",
        },
      }
    end,
  },
}
