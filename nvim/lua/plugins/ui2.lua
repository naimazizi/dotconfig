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
