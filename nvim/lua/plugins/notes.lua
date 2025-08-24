return {
  {
    "zk-org/zk-nvim",
    cond = not vim.g.vscode,
    -- event = "BufRead */notes/*.md",
    config = function()
      require("zk").setup({
        picker = "snacks_picker",
        lsp = {
          -- `config` is passed to `vim.lsp.start(config)`
          config = {
            name = "zk",
            cmd = { "zk", "lsp" },
            filetypes = { "markdown" },
          },
          -- automatically attach buffers in a zk notebook that match the given filetypes
          auto_attach = {
            enabled = true,
          },
        },
      })

      -- Open notes.
      vim.api.nvim_set_keymap(
        "n",
        "<localleader>zo",
        "<Cmd>ZkNotes { sort = { 'modified' } }<CR>",
        { noremap = true, silent = false, desc = "List All Notes" }
      )
      -- Open notes associated with the selected tags.
      vim.api.nvim_set_keymap(
        "n",
        "<localleader>zt",
        "<Cmd>ZkTags<CR>",
        { noremap = true, silent = false, desc = "List All Tags" }
      )

      -- Search for the notes matching a given query.
      vim.api.nvim_set_keymap(
        "n",
        "<localleader>zf",
        "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>",
        { noremap = true, silent = false, desc = "Search Notes" }
      )
      -- Search for the notes matching the current visual selection.
      vim.api.nvim_set_keymap(
        "v",
        "<localleader>zf",
        ":'<,'>ZkMatch<CR>",
        { noremap = true, silent = false, desc = "Search Notes" }
      )

      -- Create a new note after asking for its title.
      -- This overrides the global `<leader>zn` mapping to create the note in the same directory as the current buffer.
      vim.api.nvim_set_keymap(
        "n",
        "<localleader>zn",
        "<Cmd>ZkNew { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>",
        { noremap = true, silent = false, desc = "New Note" }
      )
      -- Create a new note in the same directory as the current buffer, using the current selection for title.
      vim.api.nvim_set_keymap(
        "v",
        "<localleader>znt",
        ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<CR>",
        { noremap = true, silent = false, desc = "New Note from Title" }
      )
      -- Create a new note in the same directory as the current buffer, using the current selection for note content and asking for its title.
      vim.api.nvim_set_keymap(
        "v",
        "<localleader>znc",
        ":'<,'>ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>",
        { noremap = true, silent = false, desc = "New Note from Content" }
      )

      -- Open notes linking to the current buffer.
      vim.api.nvim_set_keymap(
        "n",
        "<localleader>zb",
        "<Cmd>ZkBacklinks<CR>",
        { noremap = true, silent = false, desc = "Reference - Backlink" }
      )
      -- Alternative for backlinks using pure LSP and showing the source context.
      --vim.api.nvim_set_keymap('n', '<localleader>zb', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
      -- Open notes linked by the current buffer.
      vim.api.nvim_set_keymap(
        "n",
        "<localleader>zl",
        "<Cmd>ZkLinks<CR>",
        { noremap = true, silent = false, desc = "Open Link" }
      )
      require("which-key").add({ "<localleader>z", desc = "+Zk Notes", icon = "" })
    end,
  },
}
