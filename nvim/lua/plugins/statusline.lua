if vim.g.vscode then
  return
end

vim.pack.add({ Config.gh("nvim-lualine/lualine.nvim"), Config.gh("SmiteshP/nvim-navic") })

Config.on_event("VimEnter", function()
  require("lualine").setup({
    options = {
      component_separators = "",
      section_separators = { left = "", right = "" },
      globalstatus = true,
    },

    sections = {
      lualine_a = {
        {
          function()
            local reg = vim.fn.reg_recording()
            -- If a macro is being recorded, show "Recording @<register>"
            if reg ~= "" then
              return "Recording @" .. reg
            else
              -- Get the full mode name using nvim_get_mode()
              local mode = vim.api.nvim_get_mode().mode
              local mode_map = {
                n = "NORMAL",
                i = "INSERT",
                v = "VISUAL",
                V = "V-LINE",
                ["^V"] = "V-BLOCK",
                c = "COMMAND",
                R = "REPLACE",
                s = "SELECT",
                S = "S-LINE",
                ["^S"] = "S-BLOCK",
                t = "TERMINAL",
              }

              -- Return the full mode name
              return mode_map[mode] or mode:upper()
            end
          end,
          separator = { left = "" },
          right_padding = 2,
        },
      },
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
        { "location", separator = { right = "" }, left_padding = 2 },
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
  })
end)

Config.on_event("LspAttach", function()
  vim.g.navic_silence = true
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.server_capabilities and client.server_capabilities.documentSymbolProvider then
        require("nvim-navic").attach(client, args.buf)
      end
    end,
  })
end)
