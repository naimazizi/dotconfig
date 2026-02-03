return {
  "b0o/incline.nvim",
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  dependencies = {
    {
      "SmiteshP/nvim-navic",
      opts = {
        lsp = {
          auto_attach = true,
        },
      },
    },
  },
  config = function()
    local navic = require("nvim-navic")
    local mini_icons = require("mini.icons")

    require("incline").setup({
      window = {
        placement = { horizontal = "right", vertical = "top" },
        margin = { horizontal = 0, vertical = 0 },
        padding = 0,
        padding_char = " ",
        width = "fit",
        winhighlight = {
          active = {
            Normal = "InclineNormal",
            EndOfBuffer = "None",
            Search = "None",
          },
          inactive = {
            Normal = "InclineNormalNC",
            EndOfBuffer = "None",
            Search = "None",
          },
        },
        zindex = 50,
      },

      highlight = {
        groups = {
          InclineNormal = { default = true, group = "StatusLine" },
          InclineNormalNC = { default = true, group = "StatusLineNC" },
        },
      },

      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        if filename == "" then
          filename = "[No Name]"
        end
        local modified = vim.bo[props.buf].modified
        local ft_icon, ft_color = mini_icons.get("file", filename)

        local result = {}

        -- GIT DIFF (gitsigns.nvim)
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

        -- ICON box + extra space
        if ft_icon then
          table.insert(result, {
            " ",
            { gui = modified and "bold,italic" or "bold" },
            " ",
            ft_icon and { ft_icon, " ", guibg = "none", group = ft_color } or "",
          })
          table.insert(result, " ") -- spacing between icon and filename
        end

        -- FILENAME
        table.insert(result, {
          filename,
          gui = modified and "bold,italic" or "bold",
        })

        local function sep()
          return { " | ", guifg = "#585b70" }
        end

        vim.list_extend(result, get_gitsigns_diff())

        if props.focused then
          -- NAVIC
          local navic_data = navic.get_data(props.buf) or {}
          if #navic_data > 0 then
            for _, item in ipairs(navic_data) do
              table.insert(result, {
                { " > ", group = "NavicSeparator" },
                { item.icon, group = "NavicIcons" .. item.type },
                { item.name, group = "NavicText" },
              })
            end
          end

          -- DIAGNOSTICS
          local diag_icons = {
            error = "󰅚 ",
            warn = "󰅚 ",
            info = "󰅚 ",
            hint = "󰅚 ",
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
            table.insert(result, sep())
            for i, item in ipairs(entries) do
              table.insert(result, item)
              if i < #entries then
                table.insert(result, " ") -- space after all but last
              end
            end
          end

          -- CLOCK
          table.insert(result, sep())
          table.insert(result, { os.date("%H:%M") })
        end

        table.insert(result, " ")
        return result
      end,
    })
  end,
}
