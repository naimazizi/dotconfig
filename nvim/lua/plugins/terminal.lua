if vim.g.vscode then
  return
end

-- Keep lazygit's file editing in this Neovim instance and outside its float.
local function configure_lazygit_nvim_remote()
  local override = vim.fn.stdpath("cache") .. "/lazygit-nvim-remote.yml"
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
  configure_lazygit_nvim_remote()

  local terminal_win = {
    position = "float",
    row = function()
      return vim.o.lines - 19
    end,
    width = 0.98,
    height = 15,
  }
  local function toggle_terminal()
    Snacks.terminal.toggle(nil, { win = terminal_win })
  end

  local map = vim.keymap.set
  map({ "n", "t" }, "<C-/>", toggle_terminal, { desc = "Toggle terminal" })
  map({ "n", "t" }, "<C-`>", toggle_terminal, { desc = "Toggle terminal" })
  map("n", "<leader>gg", function()
    Snacks.terminal.toggle("lazygit", {
      win = {
        on_buf = function(term)
          term:on("TermClose", function()
            if package.loaded["nvim-tree.api"] then
              require("nvim-tree.api").tree.reload()
            end
          end, { buf = true })
        end,
      },
    })
  end, { desc = "Lazygit" })
end)
