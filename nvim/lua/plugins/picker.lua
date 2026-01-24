return {
  {
    "dmtrKovalenko/fff.nvim",
    vscode = false,
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    dependencies = {
      "folke/snacks.nvim",
    },
    opts = {
      prompt = " ",
      title = "Find Files",
    },
    lazy = false,
  },
  {
    "ibhagwan/fzf-lua",
    vscode = false,
    event = "VeryLazy",
    dependencies = {
      "folke/snacks.nvim",
    },
    config = function()
      local fzf = require("fzf-lua")
      local config = fzf.config
      local actions = fzf.actions

      -- Quickfix
      config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
      config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
      config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
      config.defaults.keymap.fzf["ctrl-x"] = "jump"
      config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
      config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"
      config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
      config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"

      local img_previewer ---@type string[]?
      for _, v in ipairs({
        { cmd = "ueberzug", args = {} },
        { cmd = "chafa", args = { "{file}", "--format=symbols" } },
        { cmd = "viu", args = { "-b" } },
      }) do
        if vim.fn.executable(v.cmd) == 1 then
          img_previewer = vim.list_extend({ v.cmd }, v.args)
          break
        end
      end

      fzf.setup({
        "default-title",
        fzf_colors = true,
        fzf_opts = {
          ["--no-scrollbar"] = true,
        },
        previewers = {
          builtin = {
            extensions = {
              ["png"] = img_previewer,
              ["jpg"] = img_previewer,
              ["jpeg"] = img_previewer,
              ["gif"] = img_previewer,
              ["webp"] = img_previewer,
            },
            ueberzug_scaler = "fit_contain",
          },
        },
        -- Custom LazyVim option to configure vim.ui.select
        ui_select = function(fzf_opts, items)
          return vim.tbl_deep_extend("force", fzf_opts, {
            prompt = " ",
            winopts = {
              title = " " .. vim.trim((fzf_opts.prompt or "Select"):gsub("%s*:%s*$", "")) .. " ",
              title_pos = "center",
            },
          }, fzf_opts.kind == "codeaction" and {
            winopts = {
              layout = "vertical",
              -- height is number of items minus 15 lines for the preview, with a max of 80% screen height
              height = math.floor(math.min(vim.o.lines * 0.8 - 16, #items + 4) + 0.5) + 16,
              width = 0.5,
              preview = not vim.tbl_isempty(vim.lsp.get_clients({ bufnr = 0, name = "vtsls" })) and {
                layout = "vertical",
                vertical = "down:15,border-top",
                hidden = "hidden",
              } or {
                layout = "vertical",
                vertical = "down:15,border-top",
              },
            },
          } or {
            winopts = {
              width = 0.5,
              -- height is number of items, with a max of 80% screen height
              height = math.floor(math.min(vim.o.lines * 0.8, #items + 4) + 0.5),
            },
          })
        end,
        winopts = {
          width = 0.8,
          height = 0.8,
          row = 0.5,
          col = 0.5,
          preview = {
            scrollchars = { "┃", "" },
          },
        },
        files = {
          cwd_prompt = false,
          path_shorten = 1,
          formatter = "path.filename_first",
          actions = {
            ["alt-i"] = { actions.toggle_ignore },
            ["alt-h"] = { actions.toggle_hidden },
          },
        },
        grep = {
          actions = {
            ["alt-i"] = { actions.toggle_ignore },
            ["alt-h"] = { actions.toggle_hidden },
          },
          multiline = 2,
        },
        lsp = {
          symbols = {
            symbol_style = 2,
          },
        },
      })
      fzf.register_ui_select()
    end,
  },
  {
    "folke/snacks.nvim",
    vscode = false,
    event = "VeryLazy",
    ---@type snacks.Config
    opts = {
      image = {},

      input = {},

      quickfile = {},

      bigfile = {},

      terminal = {},

      gitbrowse = {},

      gh = {},

      lazygit = {},

      indent = {
        indent = {
          priority = 1,
          enabled = true, -- enable indent guides
          char = "╎",
          only_scope = false, -- only show indent guides of the scope
          only_current = false, -- only show indent guides in the current window
          hl = "SnacksIndent",
        },
        animate = {
          style = "out",
          easing = "linear",
          duration = {
            step = 20, -- ms per step
            total = 500, -- maximum duration
          },
        },
        scope = {
          enabled = true, -- enable highlighting the current scope
          priority = 200,
          char = "│",
          underline = false, -- underline the start of the scope
          only_current = true, -- only show scope in the current window
          hl = "SnacksIndentScope", ---@type string|string[] hl group for scopes
        },
        chunk = {
          -- when enabled, scopes will be rendered as chunks, except for the
          -- top-level scope which will be rendered as a scope.
          enabled = true,
          -- only show chunk scopes in the current window
          only_current = true,
          priority = 200,
          hl = "SnacksIndentChunk", ---@type string|string[] hl group for chunk scopes
          char = {
            corner_top = "╭",
            corner_bottom = "╰",
            horizontal = "─",
            vertical = "│",
            arrow = ">",
          },
        },
      },
    },
  },
}
