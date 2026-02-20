return {
  {
    "stevearc/quicker.nvim",
    vscode = false,
    event = "VeryLazy",
    ft = "qf",
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {
      -- Keep the cursor to the right of the filename and lnum columns
      constrain_cursor = true,
      -- Local options to set for quickfix
      opts = {
        wrap = true,
      },
      -- Use default options
      use_default_opts = true,
      -- Keymaps to set for the quickfix buffer
      keys = {
        {
          ">",
          function()
            require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
          end,
          desc = "Expand quickfix context",
        },
        {
          "<",
          function()
            require("quicker").collapse()
          end,
          desc = "Collapse quickfix context",
        },
      },
      -- Enable editing the quickfix like a normal buffer
      edit = {
        enabled = true,
        -- Autosave unmodified buffers only
        autosave = "unmodified",
      },
      -- Syntax highlighting options
      highlight = {
        treesitter = true,
        lsp = true,
        load_buffers = false,
      },
    },
    config = function(_, opts)
      require("quicker").setup(opts)

      -- Keymaps for toggling quickfix and loclist
      vim.keymap.set("n", "<leader>xq", function()
        require("quicker").toggle()
      end, {
        desc = "Toggle quickfix",
      })

      vim.keymap.set("n", "<leader>xl", function()
        require("quicker").toggle({ loclist = true })
      end, {
        desc = "Toggle loclist",
      })
    end,
  },
}
