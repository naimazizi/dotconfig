return {
  {
    "neoclide/coc.nvim",
    branch = "release",
    event = { "BufReadPre", "BufNewFile" },
    vscode = false,
    init = function()
      -- Install desired extensions with :CocInstall
      vim.g.coc_global_extensions = {
        "coc-json",
        "coc-yaml",
        "coc-toml",
        "coc-snippets",
        "coc-sumneko-lua",
        "coc-typos",
        "@hexuhua/coc-copilot",
        "@yaegassy/coc-marksman",
        "@yaegassy/coc-ruff",
        "@yaegassy/coc-pyrefly",
        "coc-lightbulb",
      }

      -- Recommended by coc.nvim docs (diagnostics update)
      vim.o.updatetime = 250
      vim.o.signcolumn = "yes"
    end,
    config = function()
      vim.g.coc_disable_startup_warning = 1

      vim.api.nvim_create_user_command("OrganizeImports", function()
        vim.cmd("CocActionAsync runCommand editor.action.organizeImport")
      end, {})

      vim.api.nvim_create_autocmd("CursorHold", {
        group = vim.api.nvim_create_augroup("coc-cursorhold", { clear = true }),
        callback = function()
          if vim.g.coc_service_initialized == 1 then
            vim.fn.CocActionAsync("highlight")
          end
        end,
      })
    end,
  },
  {
    "github/copilot.vim",
    event = "VeryLazy",
    vscode = false,
  },
}
