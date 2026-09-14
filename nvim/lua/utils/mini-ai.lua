local M = {}

function M.ai_setup()
  local ai = require("mini.ai")
  local ai_opts = {
    n_lines = 500,
    custom_textobjects = {
      o = ai.gen_spec.treesitter({ -- code block
        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
      }),
      f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
      c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
      t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
      d = { "%f[%d]%d+" }, -- digits
      e = { -- Word with case
        { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
        "^().*()$",
      },
      u = ai.gen_spec.function_call(), -- u for "Usage"
      U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
      r = function(ai_mode, _, _) -- r for "cell"
        local buf_nlines = vim.api.nvim_buf_line_count(0)
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local cell_markers = {}
        for line_no, line in ipairs(lines) do
          if line:match("^# *%%%%") then
            table.insert(cell_markers, line_no)
          end
        end
        table.insert(cell_markers, 1, 0) -- Beginning
        table.insert(cell_markers, #cell_markers + 1, buf_nlines + 1)
        local regions = {}
        for i = 1, #cell_markers - 1 do
          local from_line, to_line
          if ai_mode == "i" then
            from_line = cell_markers[i] + 1
            to_line = cell_markers[i + 1] - 1
          else
            from_line = math.max(cell_markers[i], 1)
            to_line = cell_markers[i + 1] - 1
          end
          local to_line_len = #(lines[to_line] or "") + 1
          table.insert(regions, {
            from = { line = from_line, col = 1 },
            to = { line = to_line, col = to_line_len },
          })
        end
        return regions
      end,
    },
  }
  ai.setup(ai_opts)
end

return M
