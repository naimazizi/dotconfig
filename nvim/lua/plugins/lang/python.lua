vim.pack.add({ Config.gh("linux-cultist/venv-selector.nvim") })

Config.on_filetype("python", function()
  require("venv-selector").setup({
    options = {
      notify_user_on_venv_activation = true,
      statusline_func = {
        lualine = function()
          local venv_path = require("venv-selector").venv()
          if not venv_path or venv_path == "" then
            return ""
          end

          local venv_name = vim.fn.fnamemodify(venv_path, ":t")
          if not venv_name then
            return ""
          end

          local output = "󱔎 " .. venv_name .. " "
          return output
        end,
      },
    },
  })

  vim.keymap.set("n", "<leader>cv", "<cmd>:VenvSelect<cr>", { desc = "Select VirtualEnv" })
end)

-- neotest-python adapter registration lives in plugins/test.lua directly
-- (was a lazy.nvim `optional = true` opts-merge contribution here).
