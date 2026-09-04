return {
  {
    "nvim-lualine/lualine.nvim",
    vscode = false,
    event = "VimEnter",
    dependencies = { "SmiteshP/nvim-navic" },
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
              local icons = { FAILURE = "󰅚", CANCELED = "", SUCCESS = "󰄴", RUNNING = "󰑮" }
              local counts = {}
              for _, task in ipairs(require("overseer").list_tasks()) do
                counts[task.status] = (counts[task.status] or 0) + 1
              end
              local parts = {}
              for _, status in ipairs({ "FAILURE", "RUNNING", "SUCCESS", "CANCELED" }) do
                if counts[status] then
                  table.insert(parts, icons[status] .. counts[status])
                end
              end
              return table.concat(parts, " ")
            end,
            cond = function()
              return package.loaded["overseer"] ~= nil
            end,
          },
          "quickfix",
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
        },
        lualine_y = {
          "fileformat",
          "encoding",
          "lsp_status",
          {
            function()
              return require("opencode").statusline()
            end,
            cond = function()
              return package.loaded["opencode"] ~= nil
            end,
          },
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
