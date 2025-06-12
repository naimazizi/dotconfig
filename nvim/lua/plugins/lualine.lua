return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    vscode = false,
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = " "
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      -- PERF: we don't need this lualine require madness 🤷
      local lualine_require = require("lualine_require")
      lualine_require.require = require

      local icons = LazyVim.config.icons

      vim.o.laststatus = vim.g.lualine_laststatus

      -- local dmode_enabled = false
      -- vim.api.nvim_create_autocmd("User", {
      --   pattern = "DebugModeChanged",
      --   callback = function(args)
      --     dmode_enabled = args.data.enabled
      --   end,
      -- })

      local opts = {
        options = {
          theme = "auto",
          globalstatus = vim.o.laststatus == 3,
          disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
        },
        sections = {
          lualine_a = {
            "mode",
            -- {
            --   "mode",
            --   fmt = function(str)
            --     return dmode_enabled and "DEBUG" or str
            --   end,
            --   color = function(tb)
            --     return dmode_enabled and "dCursor" or tb
            --   end,
            -- },
          },
          lualine_b = { "branch" },

          lualine_c = {
            LazyVim.lualine.root_dir(),
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
            { "filetype",                   icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { LazyVim.lualine.pretty_path() },
          },
          lualine_x = {
            Snacks.profiler.status(),
            -- stylua: ignore
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
              color = function() return { fg = Snacks.util.color("Statement") } end,
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = function() return { fg = Snacks.util.color("Constant") } end,
            },
            -- stylua: ignore
            {
              function() return "  " .. require("dap").status() end,
              cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = function() return { fg = Snacks.util.color("Debug") } end,
            },
            -- stylua: ignore
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = function() return { fg = Snacks.util.color("Special") } end,
            },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
          },
          lualine_y = {
            { "progress",                      separator = " ",                  padding = { left = 1, right = 0 } },
            { "location",                      padding = { left = 0, right = 1 } },
            { require("recorder").displaySlots },
            { "harpoon2" },
          },
          lualine_z = {
            function()
              return " " .. os.date("%R")
            end,
          },
        },
        extensions = { "lazy", "overseer", "trouble" },
      }

      if vim.g.trouble_lualine then
        table.insert(opts.sections.lualine_c, { "navic", color_correction = "dynamic" })
      end

      if LazyVim.has("git-blame.nvim") then
        local git_blame = require("gitblame")
        table.insert(
          opts.sections.lualine_c,
          { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available }
        )
      end

      return opts
    end,
  },
  {
    "SmiteshP/nvim-navic",
    opts = {
      highlight = false,
    },
  },
  {
    "letieu/harpoon-lualine",
  },
}
