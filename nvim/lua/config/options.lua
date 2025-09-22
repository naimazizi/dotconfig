---@diagnostic disable: missing-fields, assign-type-mismatch
-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local function paste()
  return {
    vim.fn.split(vim.fn.getreg(""), "\n"),
    vim.fn.getregtype(""),
  }
end

local function is_ssh_session()
  return vim.env.SSH_CONNECTION ~= nil or vim.env.SSH_CLIENT ~= nil or vim.env.SSH_TTY ~= nil
end

vim.o.spell = false

if not vim.g.vscode then
  -- ordinary Neovim

  vim.g.lazyvim_picker = "snacks"
  vim.g.root_spec = { "cwd" }

  vim.o.guifont = "JetBrains Maple Mono:h11:#e-subpixelantialias"
  vim.o.smoothscroll = false

  if is_ssh_session() then
    vim.g.clipboard = {
      name = "OSC 52",
      copy = {
        ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
        ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
      },
      paste = {
        ["+"] = paste,
        ["*"] = paste,
      },
    }
  end

  local function system(command)
    local file = io.popen(command, "r")
    local output = file:read("*all"):gsub("%s+", "")
    file:close()
    return output
  end

  vim.g.python3_host_prog = system("which python")
elseif vim.g.vscode then
  -- Fix ghost font
  local redraw_fix = vim.api.nvim_create_augroup("VSCodeRedrawFix", { clear = true })
  vim.api.nvim_create_autocmd("CursorHold", {
    group = redraw_fix,
    callback = function()
      vim.cmd("silent! mode") -- triggers a lightweight redraw
    end,
  })

  -- 2. Redraw immediately after text changes (e.g., visual delete)
  local redraw_group = vim.api.nvim_create_augroup("RedrawOnDelete", { clear = true })
  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    group = redraw_group,
    callback = function()
      if vim.fn.mode() == "n" then
        vim.cmd("silent! mode") -- refresh UI after delete/insert
      end
    end,
  })
end
