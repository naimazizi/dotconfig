if vim.g.vscode then
  return
end

vim.pack.add({ Config.gh("ingur/floatty.nvim") })

-- Tell lazygit to open files in this running nvim instead of spawning a new
-- one, via its built-in `nvim-remote` editor preset. `$NVIM` is set
-- automatically by Neovim for any `:terminal`/`jobstart(..., {term=true})`
-- child, so no extra wiring is needed on our side.
local function configure_lazygit_nvim_remote()
  local override = vim.fn.stdpath("cache") .. "/lazygit-nvim-remote.yml"
  -- Leave the terminal float before --remote opens the file in the current tab.
  vim.fn.writefile({
    "os:",
    '  editPreset: "nvim-remote"',
    [[  edit: 'nvim --server "$NVIM" --remote-send "q<C-\><C-n><C-w>p" && nvim --server "$NVIM" --remote {{filename}}']],
    [[  editAtLine: 'nvim --server "$NVIM" --remote-send "q<C-\><C-n><C-w>p" && nvim --server "$NVIM" --remote {{filename}} && nvim --server "$NVIM" --remote-send ":{{line}}<CR>"']],
  }, override)

  local files = {}
  local out = vim.fn.system({ "lazygit", "-cd" })
  if vim.v.shell_error == 0 then
    local default_config = vim.trim(vim.split(out, "\n")[1] or "") .. "/config.yml"
    if vim.uv.fs_stat(default_config) then
      files[1] = default_config
    end
  end
  table.insert(files, override)
  vim.env.LG_CONFIG_FILE = table.concat(files, ",")
end

Config.later(function()
  local term = require("floatty").setup({
    window = {
      row = function()
        return vim.o.lines - 19
      end,
      width = 0.98,
      height = 15,
    },
  })

  configure_lazygit_nvim_remote()

  local lazygit = require("floatty").setup({
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
          if package.loaded["nvim-tree.api"] then
            require("nvim-tree.api").tree.reload()
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

  local map = vim.keymap.set
  map({ "n", "t" }, "<C-/>", function()
    term.toggle()
  end, { desc = "Toggle terminal" })
  map({ "n", "t" }, "<C-`>", function()
    term.toggle()
  end, { desc = "Toggle terminal" })
  map("n", "<leader>gg", function()
    lazygit.toggle()
  end, { desc = "Lazygit" })
end)
