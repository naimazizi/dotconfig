return {
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    vscode = false,
    config = function(_, opts)
      require("bqf").setup(opts)

      local function delete_qf_items(visual)
        local qflist = vim.fn.getqflist()
        local loclist = vim.fn.getloclist(0)
        local is_loc = vim.fn.getloclist(0, { winid = 0 }).winid ~= 0

        local list = is_loc and loclist or qflist
        local start_idx, end_idx

        if visual then
          start_idx = vim.fn.line("'<")
          end_idx = vim.fn.line("'>")
        else
          start_idx = vim.fn.line(".")
          end_idx = start_idx
        end

        for i = end_idx, start_idx, -1 do
          table.remove(list, i)
        end

        if is_loc then
          vim.fn.setloclist(0, {}, "r", { items = list })
        else
          vim.fn.setqflist({}, "r", { items = list })
        end

        local new_line = math.min(start_idx, #list)
        if new_line > 0 then
          vim.api.nvim_win_set_cursor(0, { new_line, 0 })
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "qf",
        callback = function(ev)
          vim.keymap.set("n", "dd", function()
            delete_qf_items(false)
          end, { buffer = ev.buf, desc = "Delete quickfix entry" })
          vim.keymap.set("v", "d", function()
            vim.cmd("normal! \27") -- exit visual mode
            delete_qf_items(true)
          end, { buffer = ev.buf, desc = "Delete quickfix entries" })
        end,
      })
    end,
    opts = {
      auto_enable = true,
      auto_resize_height = true,
      preview = {
        win_height = 15,
        win_vheight = 15,
        delay_syntax = 80,
        border = "rounded",
        show_title = true,
        show_scroll_bar = true,
        wrap = false,
        buf_label = true,
      },
    },
  },
}
