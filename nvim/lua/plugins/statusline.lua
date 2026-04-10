return {
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = { "SmiteshP/nvim-navic" },
    config = function()
      require("lualine").setup({
        options = {
          component_separators = "",
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
          lualine_b = {
            "branch",
            {
              function()
                return vim.fn.getcwd()
              end,
            },
            "encoding",
            "fileformat",
            "filetype",
            "navic",
          },
          lualine_c = {
            "%=",
          },
          lualine_x = { "overseer", "quickfix" },
          lualine_y = { "lsp_status" },
          lualine_z = {
            "filesize",
            "progress",
            { "location", separator = { right = "" }, left_padding = 2 },
          },
        },
        inactive_sections = {
          lualine_a = { "filename" },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = { "location" },
        },
        tabline = {},
        extensions = { "overseer", "quickfix" },
      })
    end,
  },
  {
    "SmiteshP/nvim-navic",
    event = "LspAttach",
    config = function()
      vim.g.navic_silence = true
      Snacks.util.lsp.on({ method = "textDocument/documentSymbol" }, function(buffer, client)
        require("nvim-navic").attach(client, buffer)
      end)
    end,
  },
  {
    "b0o/incline.nvim",
    event = "VeryLazy",
    config = function()
      require("incline").setup({
        window = {
          padding = 0,
          margin = { horizontal = 0, vertical = 0 },
          winhighlight = {
            active = {
              Normal = "StatusLine",
            },
            inactive = {
              Normal = "StatusLine",
            },
          },
        },
        render = function(props)
          local result = {}

          local fullpath = vim.api.nvim_buf_get_name(props.buf)
          local reldir
          if fullpath == "" then
            reldir = ""
          else
            reldir = vim.fn.fnamemodify(fullpath, ":~:.:h")
            if reldir == "." then
              reldir = ""
            end
          end
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          local ft_icon, ft_color = require("mini.icons").get("file", filename)
          local modified = vim.bo[props.buf].modified

          -- Relative path
          if reldir ~= "" then
            table.insert(result, {
              reldir == "" and reldir or (reldir .. "/"),
              gui = "italic",
            })
          end

          local buffer = {
            { filename, gui = modified and "bold,italic" or "bold" },
            " ",
            ft_icon and {
              ft_icon,
              guibg = ft_color,
              guifg = ft_color,
            } or "",
          }
          table.insert(result, buffer)

          local function get_gitsigns_diff()
            local dict = vim.b[props.buf].gitsigns_status_dict
            if type(dict) ~= "table" then
              return {}
            end

            local items = {
              { key = "added", icon = " ", group = "GitSignsAdd" },
              { key = "changed", icon = " ", group = "GitSignsChange" },
              { key = "removed", icon = " ", group = "GitSignsDelete" },
            }

            local labels = {}
            for _, item in ipairs(items) do
              local n = tonumber(dict[item.key]) or 0
              if n > 0 then
                table.insert(labels, { " ", item.icon .. n, group = item.group })
              end
            end

            return labels
          end

          vim.list_extend(result, get_gitsigns_diff())

          local diag_icons = {
            error = " ",
            warn = " ",
            info = " ",
            hint = " ",
          }
          local entries = {}

          for severity, icon in pairs(diag_icons) do
            local count = #vim.diagnostic.get(props.buf, {
              severity = vim.diagnostic.severity[string.upper(severity)],
            })
            if count > 0 then
              table.insert(entries, {
                icon .. " " .. count,
                group = "DiagnosticSign" .. severity,
              })
            end
          end

          if #entries > 0 then
            for i, item in ipairs(entries) do
              table.insert(result, item)
              if i < #entries then
                table.insert(result, " ") -- space after all but last
              end
            end
          end

          return result
        end,
      })
    end,
  },
}
