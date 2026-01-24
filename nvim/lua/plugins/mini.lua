local function ai_buffer(ai_type)
  local start_line, end_line = 1, vim.fn.line("$")
  if ai_type == "i" then
    -- Skip first and last blank lines for `i` textobject
    local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
    -- Do nothing for buffer with all blanks
    if first_nonblank == 0 or last_nonblank == 0 then
      return { from = { line = start_line, col = 1 } }
    end
    start_line, end_line = first_nonblank, last_nonblank
  end

  local to_col = math.max(vim.fn.getline(end_line):len(), 1)
  return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
end

local censor_extmark_opts = function(buf_id, match, data)
  local mask = string.rep("⎯", vim.api.nvim_win_get_width(0))
  return {
    virt_text = { { mask, "SignColumn" } },
    virt_text_pos = "overlay",
    virt_text_hide = true,
    priority = 200,
    right_gravity = false,
  }
end

local function ai_whichkey(opts)
  local objects = {
    { " ", desc = "whitespace" },
    { '"', desc = '" string' },
    { "'", desc = "' string" },
    { "(", desc = "() block" },
    { ")", desc = "() block with ws" },
    { "<", desc = "<> block" },
    { ">", desc = "<> block with ws" },
    { "?", desc = "user prompt" },
    { "U", desc = "use/call without dot" },
    { "[", desc = "[] block" },
    { "]", desc = "[] block with ws" },
    { "_", desc = "underscore" },
    { "`", desc = "` string" },
    { "a", desc = "argument" },
    { "b", desc = ")]} block" },
    { "c", desc = "class" },
    { "d", desc = "digit(s)" },
    { "e", desc = "CamelCase / snake_case" },
    { "f", desc = "function" },
    { "g", desc = "entire file" },
    { "i", desc = "indent" },
    { "o", desc = "block, conditional, loop" },
    { "q", desc = "quote `\"'" },
    { "t", desc = "tag" },
    { "u", desc = "use/call" },
    { "{", desc = "{} block" },
    { "}", desc = "{} with ws" },
  }

  ---@type wk.Spec[]
  local ret = { mode = { "o", "x" } }
  ---@type table<string, string>
  local mappings = vim.tbl_extend("force", {}, {
    around = "a",
    inside = "i",
    around_next = "an",
    inside_next = "in",
    around_last = "al",
    inside_last = "il",
  }, opts.mappings or {})
  mappings.goto_left = nil
  mappings.goto_right = nil

  for name, prefix in pairs(mappings) do
    name = name:gsub("^around_", ""):gsub("^inside_", "")
    ret[#ret + 1] = { prefix, group = name }
    for _, obj in ipairs(objects) do
      local desc = obj.desc
      if prefix:sub(1, 1) == "i" then
        desc = desc:gsub(" with ws", "")
      end
      ret[#ret + 1] = { prefix .. obj[1], desc = obj.desc }
    end
  end
  require("which-key").add(ret, { notify = false })
end

return {
  {
    "nvim-mini/mini.nvim",
    version = false,
    lazy = false,
    config = function()
      require("mini.notify").setup()
      vim.notify = require("mini.notify").make_notify()
      require("mini.statusline").setup()
      require("mini.tabline").setup()
      require("mini.bufremove").setup()
      require("mini.cmdline").setup({
        autocomplete = { enable = false },
        autocorrect = { enable = false },
        autopeek = { enable = true },
      })

      require("mini.icons").setup()
      require("mini.icons").mock_nvim_web_devicons()

      local hipatterns = require("mini.hipatterns")
      hipatterns.setup({
        highlighters = {
          fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
          hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
          todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
          note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
          hex_color = hipatterns.gen_highlighter.hex_color(),
          cell_marker = {
            pattern = function(bufid)
              local cmt_str = vim.api.nvim_get_option_value("commentstring", { buf = bufid })
              return "^" .. string.gsub(cmt_str, [[%s]], "") .. [[*%%.*]]
            end,
            group = "",
            extmark_opts = censor_extmark_opts,
          },
        },
      })

      require("mini.basics").setup({
        -- Options. Set field to `false` to disable.
        options = {
          -- Basic options ('number', 'ignorecase', and many more)
          basic = true,

          -- Extra UI features ('winblend', 'listchars', 'pumheight', ...)
          extra_ui = true,

          -- Presets for window borders ('single', 'double', ...)
          -- Default 'auto' infers from 'winborder' option
          win_borders = "auto",
        },

        -- Mappings. Set field to `false` to disable.
        mappings = {
          -- Basic mappings (better 'jk', save with Ctrl+S, ...)
          basic = true,

          -- Prefix for mappings that toggle common options ('wrap', 'spell', ...).
          -- Supply empty string to not create these mappings.
          option_toggle_prefix = "<leader>u",

          -- Window navigation with <C-hjkl>, resize with <C-arrow>
          windows = true,

          -- Move cursor in Insert, Command, and Terminal mode with <M-hjkl>
          move_with_alt = true,
        },

        -- Autocommands. Set field to `false` to disable
        autocommands = {
          -- Basic autocommands (highlight on yank, start Insert in terminal, ...)
          basic = true,

          -- Set 'relativenumber' only in linewise and blockwise Visual mode
          relnum_in_visual_mode = true,
        },

        -- Whether to disable showing non-error feedback
        silent = false,
      })

      require("mini.surround").setup({
        mappings = {
          add = "gsa", -- Add surrounding in Normal and Visual modes
          delete = "gsd", -- Delete surrounding
          find = "gsf", -- Find surrounding (to the right)
          find_left = "gsF", -- Find surrounding (to the left)
          highlight = "gsh", -- Highlight surrounding
          replace = "gsr", -- Replace surrounding
          update_n_lines = "gsn", -- Update `n_lines`
        },
      })

      require("mini.move").setup()

      require("mini.operators").setup({
        evaluate = {
          prefix = "", -- disable default mapping
          -- Function which does the evaluation
          func = nil,
        },

        -- Exchange text regions
        exchange = {
          prefix = "", -- disable default mapping
          -- Whether to reindent new text to match previous indent
          reindent_linewise = true,
        },

        -- Multiply (duplicate) text
        multiply = {
          prefix = "gm",
          -- Function which can modify text before multiplying
          func = nil,
        },

        -- Replace text with register
        replace = {
          prefix = "gv",
          -- Whether to reindent new text to match previous indent
          reindent_linewise = true,
        },

        -- Sort text
        sort = {
          prefix = "gS",
          -- Function which does the sort
          func = nil,
        },
      })

      require("mini.comment").setup({
        -- Options which control module behavior
        options = {
          -- Function to compute custom 'commentstring' (optional)
          custom_commentstring = nil,

          -- Whether to ignore blank lines when commenting
          ignore_blank_line = false,

          -- Whether to ignore blank lines in actions and textobject
          start_of_line = false,

          -- Whether to force single space inner padding for comment parts
          pad_comment_parts = true,
        },

        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
          -- Toggle comment (like `gcip` - comment inner paragraph) for both
          -- Normal and Visual modes
          comment = "gc",

          -- Toggle comment on current line
          comment_line = "gcc",

          -- Toggle comment on visual selection
          comment_visual = "gc",

          -- Define 'comment' textobject (like `dgc` - delete whole comment block)
          -- Works also in Visual mode if mapping differs from `comment_visual`
          textobject = "gc",
        },

        -- Hook functions to be executed at certain stage of commenting
        hooks = {
          -- Before successful commenting. Does nothing by default.
          pre = function() end,
          -- After successful commenting. Does nothing by default.
          post = function() end,
        },
      })
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
          g = ai_buffer, -- buffer
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
          r = function(ai_mode, _, _) -- r for "cell"
            local buf_nlines = vim.api.nvim_buf_line_count(0)
            local cell_markers = {}
            for line_no = 1, buf_nlines do
              local line = vim.fn.getline(line_no)
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
              ---@diagnostic disable-next-line: param-type-mismatch
              -- for `around cell` on empty line select previous cell
              local to_line_len = vim.fn.getline(to_line):len() + 1
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
      ai_whichkey(ai_opts)

      require("mini.sessions").setup({
        autoread = false,
        autowrite = true,
      })

      require("mini.starter").setup({
        evaluate_single = true,
        header = [[
  ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆          
  ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       
        ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄     
          ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    
        ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   
  ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  
⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   
⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  
⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄ 
    ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     
      ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     
                                  
    ]],
        items = {
          require("mini.starter").sections.recent_files(10, true),
          require("mini.starter").sections.sessions(5, true),
          require("mini.starter").sections.builtin_actions(),
        },
        content_hooks = {
          require("mini.starter").gen_hook.adding_bullet("• "),
          require("mini.starter").gen_hook.aligning("center", "center"),
        },
      })
    end,
  },
}
