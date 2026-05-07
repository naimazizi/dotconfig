return {
  {
    "EloiSanchez/dbt.nvim",
    cond = function()
      return vim.fn.filereadable(vim.fn.getcwd() .. "/dbt_project.yml") == 1
    end,
    ft = "sql",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          if vim.bo[args.buf].filetype == "sql" then
            vim.keymap.set(
              "n",
              "gd",
              "<cmd>DbtGoToDefinition<cr>",
              { buffer = args.buf, noremap = true, desc = "Go to Definition (DBT)" }
            )
            vim.keymap.set(
              "n",
              "gr",
              "<cmd>DbtGoToReferences<cr>",
              { buffer = args.buf, noremap = true, desc = "Go to Reference (DBT)" }
            )
          end
        end,
      })
    end,
  },
}
