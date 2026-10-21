vim.pack.add({ Config.gh("Saecki/crates.nvim"), Config.gh("mrcjkb/rustaceanvim") })

Config.on_event("BufReadPre~Cargo.toml", function()
  require("crates").setup({
    completion = {
      crates = {
        enabled = true,
      },
    },
    lsp = {
      enabled = true,
      completion = true,
    },
  })
end)

vim.g.rustaceanvim = function()
  local opts = {
    server = {
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
          checkOnSave = false,
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
  local library_path = vim.fn.stdpath("data") .. "/mason/opt/lldb/lib/liblldb" .. codelldb_lib_ext
  opts.dap = {
    adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb, library_path),
  }
  return opts
end
