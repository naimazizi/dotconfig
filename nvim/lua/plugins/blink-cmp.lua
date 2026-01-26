return {
  { -- Autocompletion
    "saghen/blink.cmp",
    vscode = false,
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
              require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
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
      "Fildo7525/pretty_hover",
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
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
            if is_multi_line or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
              vim.g.blink_cmp_upwards_ctx_id = ctx.id
              return { "n", "s" }
            end
            return { "s", "n" }
          end,
          border = "rounded",
        },
        documentation = {
          auto_show = true,
          window = { border = "rounded" },
          draw = function(opts)
            if opts.item and opts.item.documentation and opts.item.documentation.value then
              local out = require("pretty_hover.parser").parse(opts.item.documentation.value)
              opts.item.documentation.value = out:string()
            end
            opts.default_implementation(opts)
          end,
        },
        ghost_text = {
          enabled = true,
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
    },
  },
}
