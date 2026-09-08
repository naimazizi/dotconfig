if vim.g.vscode then
  return
end

vim.pack.add({
  Config.gh("L3MON4D3/LuaSnip"),
  Config.gh("rafamadriz/friendly-snippets"),
  Config.gh("jmbuhr/cmp-pandoc-references"),
  Config.gh("mayromr/blink-cmp-dap"),
  Config.gh("cursortab/cursortab.nvim"),
  Config.gh("saghen/blink.lib"), -- blink.cmp v2 dependency
  Config.gh("saghen/blink.cmp"),
})

local function run_build(name, cmd, cwd)
  local result = vim.system(cmd, { cwd = cwd }):wait()
  if result.code ~= 0 then
    local stderr = result.stderr or ""
    local stdout = result.stdout or ""
    local output = stderr ~= "" and stderr or stdout
    if output == "" then
      output = "No output from build command."
    end
    vim.notify(("Build failed for %s:\n%s"):format(name, output), vim.log.levels.ERROR)
  end
end

local INSTALL_OR_UPDATE = { "install", "update" }

Config.on_packchanged("LuaSnip", INSTALL_OR_UPDATE, function(data)
  if vim.fn.has("win32") ~= 1 and vim.fn.executable("make") == 1 then
    run_build("LuaSnip", { "make", "install_jsregexp" }, data.path)
  end
end, "Build LuaSnip jsregexp support")

Config.on_packchanged("blink.cmp", INSTALL_OR_UPDATE, function()
  -- `fuzzy = { implementation = "rust" }` needs this prebuilt binary.
  require("blink.cmp").build():pwait()
end, "Build blink.cmp rust fuzzy matcher")

Config.on_event("InsertEnter", function()
  -- Self-heals if the rust binary is missing/stale; build() no-ops if already built.
  require("blink.cmp").build():pwait()

  -- Snippet Engine
  require("luasnip").setup({
    history = true,
    delete_check_events = "TextChanged",
  })

  require("luasnip.loaders.from_vscode").lazy_load()
  local snippets_path = vim.fn.stdpath("config") .. "/snippets"
  if vim.fn.isdirectory(snippets_path) == 1 then
    require("luasnip.loaders.from_vscode").lazy_load({ paths = { snippets_path } })
  end

  -- Local state for tracking completion menu direction across keystrokes.
  -- Using a local variable avoids repeated vim.g reads/writes on every keypress.
  local blink_cmp_upwards_ctx_id = nil

  --- @module 'blink.cmp'
  --- @type blink.cmp.Config
  local opts = {
    snippets = {
      preset = "luasnip",
      expand = function(snippet)
        ---@diagnostic disable-next-line: redundant-return-value
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
    -- signature = { enabled = false, trigger = { show_on_accept = true }, window = { border = "rounded" } },

    sources = {
      default = {
        "lsp",
        "snippets",
        "buffer",
        "references",
      },
      per_filetype = {
        ["dap-repl"] = { "dap" },
        ["opencode_ask"] = { "lsp", "buffer" },
      },
      providers = {
        lsp = { fallbacks = {} },
        references = {
          name = "pandoc_references",
          module = "cmp-pandoc-references.blink",
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
      preset = "enter",
      ["<Tab>"] = {
        function()
          return require("cursortab").accept()
        end,
        "snippet_forward",
        "fallback",
      },
      ["<S-Tab>"] = {
        function()
          if require("cursortab.ui").has_completion() then
            require("cursortab.daemon").send_event("partial_accept")
            return true
          end
          return false
        end,
        "snippet_backward",
        "fallback",
      },
    },
  }

  require("blink.cmp").setup(opts)
end)
