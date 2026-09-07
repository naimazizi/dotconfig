vim.pack.add({ Config.gh("Saecki/crates.nvim"), Config.gh("mrcjkb/rustaceanvim") })

Config.on_event("BufReadPre~Cargo.toml", function()
  require("crates").setup({
    completion = {
      crates = {
        enabled = true,
      },
    },
    lsp = {
      enabled = false,
    },
  })
end)

Config.on_filetype("rust", function()
  local opts = {
    server = {
      on_attach = function(_, bufnr)
        vim.keymap.set("n", "<leader>cR", function()
          vim.cmd.RustLsp("codeAction")
        end, { desc = "Code Action", buffer = bufnr })
        vim.keymap.set("n", "<leader>dD", function()
          vim.cmd.RustLsp("debuggables")
        end, { desc = "DAP ft-specific", buffer = bufnr })
      end,
      default_settings = {
        -- rust-analyzer language server configuration
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true,
            loadOutDirsFromCheck = true,
            buildScripts = {
              enable = true,
            },
          },
          -- Add clippy lints for Rust if using rust-analyzer
          checkOnSave = false,
          -- Enable diagnostics if using rust-analyzer
          diagnostics = {
            enable = false,
          },
          procMacro = {
            enable = true,
          },
          files = {
            exclude = {
              ".direnv",
              ".git",
              ".jj",
              ".github",
              ".gitlab",
              "bin",
              "node_modules",
              "target",
              "venv",
              ".venv",
            },
            -- Avoid Roots Scanned hanging, see https://github.com/rust-lang/rust-analyzer/issues/12613#issuecomment-2096386344
            watcher = "client",
          },
        },
      },
    },
  }

  local codelldb = vim.fn.exepath("codelldb")
  local codelldb_lib_ext = jit.os == "Linux" and ".so" or ".dylib"
  local library_path = vim.fn.expand("$MASON/opt/lldb/lib/liblldb" .. codelldb_lib_ext)
  opts.dap = {
    adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb, library_path),
  }
  vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts)
end)

-- rustaceanvim.neotest adapter registration lives in plugins/test.lua
-- directly (was a lazy.nvim `optional = true` opts-merge contribution here).
