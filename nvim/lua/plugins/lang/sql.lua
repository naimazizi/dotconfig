vim.pack.add({ Config.gh("EloiSanchez/dbt.nvim"), Config.gh("nvim-lua/plenary.nvim") })

Config.on_filetype("sql", function()
  if vim.g.vscode or vim.fn.filereadable(vim.fn.getcwd() .. "/dbt_project.yml") == 0 then
    return
  end

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
end)
