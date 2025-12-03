return {
  {
    "tpope/vim-dadbod",
    vscode = false,
    cmd = "DB",
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    vscode = false,
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    dependencies = "vim-dadbod",
    keys = {
      { "<leader>D", "<cmd>DBUIToggle<CR>", desc = "Toggle DBUI" },
    },
    init = function()
      local data_path = vim.fn.stdpath("data")

      vim.g.db_ui_auto_execute_table_helpers = 1
      vim.g.db_ui_save_location = data_path .. "/dadbod_ui"
      vim.g.db_ui_show_database_icon = true
      vim.g.db_ui_tmp_query_location = data_path .. "/dadbod_ui/tmp"
      vim.g.db_ui_use_nerd_fonts = true
      vim.g.db_ui_use_nvim_notify = true

      vim.g.db_ui_execute_on_save = false
    end,
  },
  {
    "mfussenegger/nvim-lint",
    vscode = false,
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      local lint = require("lint")
      ---@diagnostic disable-next-line: inject-field
      lint.linters_by_ft = lint.linters_by_ft or {}
      for _, ft in ipairs(vim.g.sql_ft) do
        lint.linters_by_ft[ft] = { "sqlfluff" }
      end
    end,
  },
}
