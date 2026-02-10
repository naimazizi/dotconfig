return {
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    vscode = false,
    opts = {
      focus = true,
      warn_no_results = false,
      open_no_results = true,
      auto_preview = false,
    },
    keys = {
      {
        "<leader>cq",
        function()
          require("trouble").toggle({ mode = "diagnostics" })
        end,
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xx",
        function()
          require("trouble").toggle({ mode = "diagnostics" })
        end,
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        function()
          require("trouble").toggle({ mode = "diagnostics", filter = { buf = 0 } })
        end,
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>xl",
        function()
          require("trouble").toggle({ mode = "loclist" })
        end,
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xq",
        function()
          require("trouble").toggle({ mode = "quickfix" })
        end,
        desc = "Quickfix List (Trouble)",
      },
      {
        "<leader>xL",
        function()
          require("trouble").toggle({ mode = "loclist" })
        end,
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        function()
          require("trouble").toggle({ mode = "quickfix" })
        end,
        desc = "Quickfix List (Trouble)",
      },
      {
        "gR",
        function()
          require("trouble").toggle({ mode = "lsp_references" })
        end,
        desc = "LSP References (Trouble)",
      },
      {
        "[q",
        function()
          local ok, trouble = pcall(require, "trouble")
          if ok and type(trouble.prev) == "function" then
            trouble.prev({ skip_groups = true, jump = true })
            return
          end
          vim.cmd("cprev")
        end,
        desc = "Prev Item (Trouble/Quickfix)",
      },
      {
        "]q",
        function()
          local ok, trouble = pcall(require, "trouble")
          if ok and type(trouble.next) == "function" then
            trouble.next({ skip_groups = true, jump = true })
            return
          end
          vim.cmd("cnext")
        end,
        desc = "Next Item (Trouble/Quickfix)",
      },
    },
  },
}
