return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile", "VeryLazy" },
    cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
    opts = {
      indent = { enable = true },
      highlight = { enable = true },
      folds = { enable = true },

      -- NOTE: nvim-treesitter `main` branch moved away from `nvim-treesitter.configs`
      -- and the old `ensure_installed/auto_install` options.
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "kdl",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "ron",
        "rust",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
        "hurl",
      },
    },
    config = function(_, opts)
      local TS = require("nvim-treesitter")
      TS.setup(opts)

      local ts_install = require("nvim-treesitter.install")
      local ts_parsers = require("nvim-treesitter.parsers")

      ---Install one or more parsers (best-effort).
      ---@param languages string[]
      local function install_parsers(languages)
        if not languages or #languages == 0 then
          return
        end

        -- Filter out already-installed parsers and anything without an install config.
        local installed = TS.get_installed("parsers")
        local to_install = {}
        for _, lang in ipairs(languages) do
          if ts_parsers[lang] and not vim.list_contains(installed, lang) then
            table.insert(to_install, lang)
          end
        end

        if #to_install == 0 then
          return
        end

        -- Install in the background; avoid repeated scheduling.
        vim.g.__nvim_minimax_ts_install_queue = vim.g.__nvim_minimax_ts_install_queue or {}
        local queue = vim.g.__nvim_minimax_ts_install_queue

        local scheduled = false
        for _, lang in ipairs(to_install) do
          if not queue[lang] then
            queue[lang] = true
            scheduled = true
          end
        end

        if not scheduled then
          return
        end

        vim.schedule(function()
          local langs = {}
          for lang, _ in pairs(queue) do
            table.insert(langs, lang)
          end
          vim.g.__nvim_minimax_ts_install_queue = {}

          if #langs > 0 then
            pcall(ts_install.install, langs, { silent = true })
          end
        end)
      end

      -- Ensure configured languages are installed.
      install_parsers(opts.ensure_installed or {})

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("nvim_minimax_treesitter", { clear = true }),
        callback = function(ev)
          local ft = ev.match

          if ft == "quarto" then
            vim.treesitter.language.register("markdown", { "quarto", "rmd" })
          end

          -- Auto-install parser for the current filetype (if available).
          local lang = vim.treesitter.language.get_lang(ft) or ft
          install_parsers({ lang })

          local function enabled(feat)
            local f = opts[feat] or {}
            return f.enable ~= false
          end

          if enabled("highlight") then
            pcall(vim.treesitter.start, ev.buf)
          end

          if enabled("indent") then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end

          if enabled("folds") then
            local clients = vim.lsp.get_clients({ bufnr = ev.buf })
            local supports_folding = vim.iter(clients):any(function(client)
              return client.supports_method("textDocument/foldingRange")
            end)

            if not supports_folding then
              vim.wo.foldmethod = "expr"
              vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            end
          end
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    opts = {
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        -- LazyVim extension to create buffer-local keymaps
        keys = {
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
        },
      },
    },
    config = function(_, opts)
      local TS = require("nvim-treesitter-textobjects")
      TS.setup(opts)

      local function attach(buf)
        local ft = vim.bo[buf].filetype
        if not (vim.tbl_get(opts, "move", "enable")) then
          return
        end
        ---@type table<string, table<string, string>>
        local moves = vim.tbl_get(opts, "move", "keys") or {}

        for method, keymaps in pairs(moves) do
          for key, query in pairs(keymaps) do
            local queries = type(query) == "table" and query or { query }
            local parts = {}
            for _, q in ipairs(queries) do
              local part = q:gsub("@", ""):gsub("%..*", "")
              part = part:sub(1, 1):upper() .. part:sub(2)
              table.insert(parts, part)
            end
            local desc = table.concat(parts, " or ")
            desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
            desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")
            if not (vim.wo.diff and key:find("[cC]")) then
              vim.keymap.set({ "n", "x", "o" }, key, function()
                require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
              end, {
                buffer = buf,
                desc = desc,
                silent = true,
              })
            end
          end
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("nvim_minimax_textobjects", { clear = true }),
        callback = function(ev)
          attach(ev.buf)
        end,
      })
      vim.tbl_map(attach, vim.api.nvim_list_bufs())
    end,
  },
}
