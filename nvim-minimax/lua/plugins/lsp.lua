local function lsp_keymaps(bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end

  map("n", "gd", vim.lsp.buf.definition, "Goto definition")
  map("n", "gr", vim.lsp.buf.references, "References")
  map("n", "gi", vim.lsp.buf.implementation, "Goto implementation")
  map("n", "gy", vim.lsp.buf.type_definition, "Goto type definition")

  map("n", "K", vim.lsp.buf.hover, "Hover")

  map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
  map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")

  map("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
  map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")

  -- Keep <C-f>/<C-b> free (used for scrolling); use these for help popups
  map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
  map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
end

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "saghen/blink.cmp",
    },
    config = function()
      local lspconfig = require("lspconfig")

      local ok_blink, blink = pcall(require, "blink.cmp")
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      if ok_blink and blink.get_lsp_capabilities then
        capabilities = blink.get_lsp_capabilities(capabilities)
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          lsp_keymaps(args.buf)
        end,
      })
    end,
  },
}
