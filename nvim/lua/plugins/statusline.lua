return {
  {
    "nvim-lualine/lualine.nvim",
    vscode = false,
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons", "SmiteshP/nvim-navic" },
    opts = {
      options = {
        component_separators = "",
        section_separators = { left = "", right = "" },
        globalstatus = true,
      },
      sections = {
        lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
        lualine_b = {
          "branch",
          {
            "filename",
            path = 4,
            symbols = {
              modified = "[+]",
              readonly = "[-]",
              unnamed = "[No Name]",
              newfile = "[New]",
            },
          },
        },
        lualine_c = {
          {
            "navic",
            color_correction = "dynamic",
          },
          "%=",
        },
        lualine_x = {
          {
            function()
              local task_list = require("overseer.task_list")
              local util = require("overseer.util")
              local constants = require("overseer.constants")
              local STATUS = constants.STATUS
              local tasks = task_list.list_tasks({ unique = true })
              local tasks_by_status = util.tbl_group_by(tasks, "status")
              local pieces = {}
              local icons = {
                [STATUS.RUNNING] = "󰑮 ",
                [STATUS.FAILURE] = "󰅚 ",
                [STATUS.CANCELED] = " ",
                [STATUS.SUCCESS] = "󰄴 ",
              }
              for _, status in ipairs(STATUS.values) do
                if icons[status] and tasks_by_status[status] then
                  table.insert(pieces, icons[status] .. #tasks_by_status[status])
                end
              end
              return table.concat(pieces, " ")
            end,
            cond = function()
              return package.loaded["overseer"] ~= nil
            end,
          },
          "quickfix",
        },
        lualine_y = {
          {
            function()
              return require("recorder").displaySlots()
            end,
            cond = function()
              return package.loaded["recorder"] ~= nil
            end,
          },
          {
            function()
              return require("recorder").recordingStatus()
            end,
            cond = function()
              return package.loaded["recorder"] ~= nil
            end,
          },
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
      extensions = { "quickfix" },
    },
  },
  {
    "b0o/incline.nvim",
    enabled = false,
    event = "BufWinEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      window = {
        padding = 0,
        margin = { horizontal = 1, vertical = 0 },
        winhighlight = {
          active = {
            Normal = "StatusLine",
          },
          inactive = {
            Normal = "StatusLineNC",
          },
        },
      },
      render = function(props)
        local helpers = require("incline.helpers")
        local devicons = require("nvim-web-devicons")

        local function hl_color(name, attr)
          local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
          local val = hl[attr]
          return val and string.format("#%06x", val) or nil
        end

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
        local ft_icon, _ = devicons.get_icon(filename)
        local modified = vim.bo[props.buf].modified

        local bg_color
        local fg_color = hl_color("Normal", "fg")
        if props.focused then
          bg_color = hl_color("StatusLineNC", "fg")
        else
          bg_color = helpers.contrast_color(hl_color("StatusLine", "fg"))
        end

        table.insert(result, {
          "",
          guibg = hl_color("StatusLine", "bg"),
          guifg = bg_color,
        })

        table.insert(result, ft_icon and {
          ft_icon,
          " ",
          guibg = bg_color,
          guifg = fg_color,
        })

        -- Relative path
        if reldir ~= "" then
          table.insert(result, {
            " ",
            guibg = bg_color,
            guifg = fg_color,
          })
          table.insert(result, {
            reldir == "" and reldir or (reldir .. "/"),
            gui = "italic",
            guibg = bg_color,
            guifg = fg_color,
          })
        end

        local buffer = {
          {
            filename,
            gui = modified and "bold,italic" or "bold",
            guibg = bg_color,
            guifg = fg_color,
          },
        }
        table.insert(result, buffer)

        local function get_gitsigns_diff()
          local dict = vim.b[props.buf].gitsigns_status_dict
          if type(dict) ~= "table" then
            return {}
          end

          local items = {
            { key = "added", icon = "", group = "GitSignsAdd" },
            { key = "changed", icon = "", group = "GitSignsChange" },
            { key = "removed", icon = "", group = "GitSignsDelete" },
          }

          local labels = {}
          for _, item in ipairs(items) do
            local n = tonumber(dict[item.key]) or 0
            if n > 0 then
              table.insert(labels, {
                " ",
                item.icon .. " " .. n,
                guibg = bg_color,
                guifg = hl_color(item.group, "fg"),
              })
            end
          end

          return labels
        end

        vim.list_extend(result, get_gitsigns_diff())

        local function get_diagnostics()
          local diag_icons = {
            error = "",
            warn = "",
            info = "",
            hint = "",
          }
          local entries = {}

          for severity, icon in pairs(diag_icons) do
            local count = #vim.diagnostic.get(props.buf, {
              severity = vim.diagnostic.severity[string.upper(severity)],
            })
            if count > 0 then
              table.insert(entries, {
                " " .. icon .. " " .. count,
                -- group = "DiagnosticSign" .. severity,
                guibg = bg_color,
                guifg = hl_color("DiagnosticSign" .. severity, "fg"),
              })
            end
          end
          return entries
        end
        vim.list_extend(result, get_diagnostics())
        table.insert(result, {
          "",
          guibg = hl_color("StatusLine", "bg"),
          guifg = bg_color,
        })

        return result
      end,
    },
  },
  {
    "SmiteshP/nvim-navic",
    event = "LspAttach",
    config = function()
      vim.g.navic_silence = true
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.server_capabilities and client.server_capabilities.documentSymbolProvider then
            require("nvim-navic").attach(client, args.buf)
          end
        end,
      })
    end,
  },
}
