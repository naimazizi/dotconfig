return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tinymist = {
          keys = {
            {
              "<leader>cP",
              function()
                local buf_name = vim.api.nvim_buf_get_name(0)
                local file_name = vim.fn.fnamemodify(buf_name, ":t")
                LazyVim.lsp.execute({
                  command = "tinymist.pinMain",
                  arguments = { buf_name },
                })
                LazyVim.info("Tinymist: Pinned " .. file_name)
              end,
              desc = "Pin main file",
            },
          },
          single_file_support = true, -- Fixes LSP attachment in non-Git directories
          settings = {
            formatterMode = "typstyle",
            semanticTokens = "enable",
          },
        },
      },
    },
  },
  {
    "chomosuke/typst-preview.nvim",
    vscode = false,
    event = "VeryLazy",
    cmd = { "TypstPreview", "TypstPreviewToggle", "TypstPreviewUpdate" },
    keys = {
      {
        "<leader>cp",
        ft = "typst",
        "<cmd>TypstPreviewToggle<cr>",
        desc = "Toggle Typst Preview",
      },
    },
    opts = {
      dependencies_bin = {
        tinymist = "tinymist",
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "tinymist",
        "typstyle",
      },
    },
  },
  {
    "folke/ts-comments.nvim",
    opts = {
      lang = {
        typst = { "// %s", "/* %s */" },
      },
    },
  },
}
