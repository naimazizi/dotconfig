return {
  {
    "nvim-lualine/lualine.nvim",
    vscode = false,
    lazy = false,
    dependencies = { "SmiteshP/nvim-navic", "nvim-tree/nvim-web-devicons" },
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
            "navic",
          },
          lualine_c = {
            "%=",
          },
          lualine_x = {
            "overseer",
            "quickfix",
          },
          lualine_y = {
            { require("recorder").displaySlots },
            { require("recorder").recordingStatus },
            "fileformat",
            "encoding",
            "lsp_status",
          },
          lualine_z = {
            {
              "searchcount",
              maxcount = 999,
              timeout = 500,
            },
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
    dependencies = { "nvim-tree/nvim-web-devicons" },
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
          local helpers = require("incline.helpers")
          local devicons = require("nvim-web-devicons")

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
          ---@diagnostic disable-next-line: call-non-callable
          local ft_icon, ft_color = devicons.get_icon_color(filename)
          local modified = vim.bo[props.buf].modified

          table.insert(result, ft_icon and {
            " ",
            ft_icon,
            " ",
            guifg = helpers.contrast_color(ft_color),
            guibg = ft_color,
          })

          -- Relative path
          if reldir ~= "" then
            table.insert(result, {
              " ",
            })
            table.insert(result, {
              reldir == "" and reldir or (reldir .. "/"),
              gui = "italic",
            })
          end

          local buffer = {
            { filename, gui = modified and "bold,italic" or "bold" },
          }
          table.insert(result, buffer)

          local function get_gitsigns_diff()
            local dict = vim.b[props.buf].gitsigns_status_dict
            if type(dict) ~= "table" then
              return {}
            end

            local items = {
              { key = "added", icon = "", group = "GitSignsAdd" },
              { key = "changed", icon = "", group = "GitSignsChange" },
              { key = "removed", icon = "", group = "GitSignsDelete" },
            }

            local labels = {}
            for _, item in ipairs(items) do
              local n = tonumber(dict[item.key]) or 0
              if n > 0 then
                table.insert(labels, { " ", item.icon .. " " .. n, group = item.group })
              end
            end

            return labels
          end

          vim.list_extend(result, get_gitsigns_diff())

          local function get_diagnostics()
            local diag_icons = {
              error = "",
              warn = "",
              info = "",
              hint = "",
            }
            local entries = {}

            for severity, icon in pairs(diag_icons) do
              local count = #vim.diagnostic.get(props.buf, {
                severity = vim.diagnostic.severity[string.upper(severity)],
              })
              if count > 0 then
                table.insert(entries, {
                  " " .. icon .. " " .. count,
                  group = "DiagnosticSign" .. severity,
                })
              end
            end

            return entries
          end
          vim.list_extend(result, get_diagnostics())

          return result
        end,
      })
    end,
  },
}
