local term, lazygit

-- Tell lazygit to open files in this running nvim instead of spawning a new
-- one, via its built-in `nvim-remote` editor preset. `$NVIM` is set
-- automatically by Neovim for any `:terminal`/`jobstart(..., {term=true})`
-- child, so no extra wiring is needed on our side.
local function configure_lazygit_nvim_remote()
  local override = vim.fn.stdpath("cache") .. "/lazygit-nvim-remote.yml"
  vim.fn.writefile({ "os:", '  editPreset: "nvim-remote"' }, override)

  local files = {}
  local out = vim.fn.system({ "lazygit", "-cd" })
  if vim.v.shell_error == 0 then
    local default_config = vim.trim(vim.split(out, "\n")[1]) .. "/config.yml"
    if vim.uv.fs_stat(default_config) then
      files[1] = default_config
    end
  end
  table.insert(files, override)
  vim.env.LG_CONFIG_FILE = table.concat(files, ",")
end

return {
  {
    "ingur/floatty.nvim",
    vscode = false,
    keys = {
      {
        "<C-/>",
        function()
          term.toggle()
        end,
        mode = { "n", "t" },
        desc = "Toggle terminal",
      },
      {
        "<C-`>",
        function()
          term.toggle()
        end,
        mode = { "n", "t" },
        desc = "Toggle terminal",
      },
      {
        "<leader>gg",
        function()
          lazygit.toggle()
        end,
        desc = "Lazygit",
      },
    },
    config = function()
      term = require("floatty").setup({
        window = {
          row = function()
            return vim.o.lines - 19
          end,
          width = 0.98,
          height = 15,
        },
      })

      configure_lazygit_nvim_remote()

      lazygit = require("floatty").setup({
        cmd = "lazygit",
        id = vim.fn.getcwd, -- one persistent float per project
        on_open = function(_, buf)
          -- lazygit's `nvim-remote` edit flow quits lazygit itself (it can't
          -- suspend from inside an nvim session), so the job dies every time
          -- a file is edited. floatty has no concept of a dead job: it just
          -- keeps reopening the same "[Process exited]" buffer/window. Wipe
          -- both on exit so the next toggle spawns a fresh instance instead.
          vim.api.nvim_create_autocmd("TermClose", {
            buffer = buf,
            once = true,
            callback = function()
              if package.loaded["neo-tree.events"] then
                require("neo-tree.events").fire_event("git_event")
              end
              if package.loaded["neo-tree.sources.manager"] then
                require("neo-tree.sources.manager").refresh("filesystem")
              end
              vim.schedule(function()
                local win = vim.fn.bufwinid(buf)
                if win ~= -1 then
                  vim.api.nvim_win_close(win, true)
                end
                if vim.api.nvim_buf_is_valid(buf) then
                  vim.api.nvim_buf_delete(buf, { force = true })
                end
              end)
            end,
          })
        end,
      })
    end,
  },
}
