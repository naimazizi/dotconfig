if vim.g.vscode then
  return
end

vim.pack.add({ "https://github.com/rachartier/tiny-cmdline.nvim" })

require("vim._core.ui2").enable({
  enable = true,
  msg = {
    targets = {
      [""] = "msg",
      empty = "cmd",
      bufwrite = "msg",
      confirm = "cmd",
      emsg = "msg",
      echo = "msg",
      echomsg = "msg",
      echoerr = "msg",
      completion = "cmd",
      list_cmd = "msg",
      lua_error = "msg",
      lua_print = "msg",
      progress = "msg",
      rpc_error = "msg",
      quickfix = "msg",
      search_cmd = "cmd",
      search_count = "cmd",
      shell_cmd = "pager",
      shell_err = "pager",
      shell_out = "pager",
      shell_ret = "msg",
      undo = "msg",
      verbose = "pager",
      wildlist = "cmd",
      wmsg = "msg",
      typed_cmd = "cmd",
    },
    messagesopt = {
      maxheight = 0.5,
    },
  },
})

vim.g.tiny_cmdline = {
  width = { value = "70%" },
}
require("tiny-cmdline").setup({
  on_reposition = require("tiny-cmdline").adapters.blink,
})

local ui2 = require("vim._core.ui2")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "msg",
  callback = function()
    local win = ui2.wins and ui2.wins.msg
    if win and vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_set_option_value(
        "winhighlight",
        "Normal:NormalFloat,FloatBorder:FloatBorder",
        { scope = "local", win = win }
      )
    end
  end,
})

local msgs = require("vim._core.ui2.messages")
local orig_set_pos = msgs.set_pos
---@diagnostic disable-next-line: duplicate-set-field
msgs.set_pos = function(tgt)
  orig_set_pos(tgt)
  if (tgt == "msg" or tgt == nil) and vim.api.nvim_win_is_valid(ui2.wins.msg) then
    pcall(vim.api.nvim_win_set_config, ui2.wins.msg, {
      relative = "editor",
      anchor = "SE",
      row = vim.o.lines - 3,
      col = vim.o.columns - 1,
      border = "rounded",
    })
  end
end

vim.api.nvim_create_autocmd("LspProgress", {
  callback = function(ev)
    local value = ev.data.params.value
    vim.api.nvim_echo({ { value.message or "done" } }, true, {
      id = "lsp." .. ev.data.client_id,
      kind = "progress",
      source = "vim.lsp",
      title = value.title,
      status = value.kind ~= "end" and "running" or "success",
      percent = value.percentage,
    })
  end,
})
