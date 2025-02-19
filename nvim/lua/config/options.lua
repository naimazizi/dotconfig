-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
if vim.g.vscode then
  -- VSCode extension
  vim.keymap.set({ "n", "x", "i" }, "<C-d>", function()
    require("vscode-multi-cursor").addSelectionToNextFindMatch()
  end)
else
  -- ordinary Neovim
  if vim.fn.executable("fish") == 1 then
    vim.o.shell = "fish"
  end

  vim.g.lazyvim_picker = "snacks"
  -- python config
  -- vim.g.lazyvim_python_lsp = "basedpyright" -- Use pyright for the time being, basedpyright is slow
  vim.g.lazyvim_python_ruff = "ruff"

  opts = function()
    ---@class PluginLspOpts
    local ret = {
      ---@type lspconfig.options
      servers = {
        basedpyright = {
          typeCheckingMode = "strict",
          analysis = {
            autoSearchPaths = true,
            diagnosticMode = "openFilesOnly",
            useLibraryCodeForTypes = true,
          },
        },
        pyright = {
          typeCheckingMode = "strict",
          analysis = {
            autoSearchPaths = true,
            diagnosticMode = "openFilesOnly",
            useLibraryCodeForTypes = true,
          },
        },
        pylyzer = {
          inlayHints = true,
          checkOnType = false,
          diagnostics = false,
          smartCompletion = false,
        },
      },
    }
    return ret
  end
  config = function()
    require("blink.cmp").setup({
      completion = {
        menu = {
          draw = {
            -- We don't need label_description now because label and label_description are already
            -- combined together in label by colorful-menu.nvim.
            columns = { { "kind_icon" }, { "label", gap = 1 } },
            components = {
              label = {
                text = function(ctx)
                  return require("colorful-menu").blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require("colorful-menu").blink_components_highlight(ctx)
                end,
              },
            },
          },
        },
      },
    })
  end
end
