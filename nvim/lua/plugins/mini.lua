local pick_utils = require("utils.pick")
local clue_utils = require("utils.clue")

return {
  {
    "nvim-mini/mini.nvim",
    version = false,
    vscode = true,
    lazy = false,

    keys = {
      {
        "[T",
        function()
          require("mini.bracketed").comment("backward")
        end,
        desc = "Prev comment",
      },
      {
        "]T",
        function()
          require("mini.bracketed").comment("forward")
        end,
        desc = "Next comment",
      },
      -- mini.pick keymaps
      {
        "<leader><leader>",
        function()
          require("mini.pick").builtin.files()
        end,
        desc = "Find files",
      },
      {
        "<leader>/",
        function()
          require("mini.pick").builtin.grep_live()
        end,
        desc = "Live Grep",
      },
      {
        "<leader>sw",
        function()
          require("mini.pick").builtin.grep({ pattern = vim.fn.expand("<cword>") })
        end,
        desc = "Search current word",
      },
      {
        "<leader>ff",
        function()
          require("mini.pick").builtin.files()
        end,
        desc = "Find files",
      },
      {
        "<leader>fF",
        function()
          require("mini.pick").builtin.files(nil, { source = { cwd = vim.fn.expand("%:p:h") } })
        end,
        desc = "Find files (cwd)",
      },
      {
        "<leader>fg",
        function()
          require("mini.pick").builtin.grep_live()
        end,
        desc = "Live Grep",
      },
      {
        "<leader>sR",
        function()
          require("mini.pick").builtin.resume()
        end,
        desc = "Resume",
      },
      {
        "<leader>sk",
        function()
          require("mini.extra").pickers.keymaps()
        end,
        desc = "Keymaps",
      },
      {
        "<leader>sm",
        function()
          require("mini.extra").pickers.marks()
        end,
        desc = "Marks",
      },
      {
        "<leader>st",
        function()
          require("mini.pick").builtin.grep({ pattern = "TODO:|HACK:|PERF:|NOTE:|FIXME:" })
        end,
        desc = "TODO",
      },
      {
        "<leader>sd",
        function()
          require("mini.extra").pickers.diagnostic({ scope = "current" })
        end,
        desc = "Diagnostics",
      },
      {
        "<leader>sD",
        function()
          require("mini.extra").pickers.diagnostic({ scope = "all" })
        end,
        desc = "Diagnostics Workspace",
      },
      {
        "<leader>sq",
        function()
          require("mini.extra").pickers.list({ scope = "quickfix" })
        end,
        desc = "Quickfix",
      },
      {
        "<leader>fr",
        function()
          require("mini.extra").pickers.oldfiles()
        end,
        desc = "Recent",
      },
      {
        "<leader>fh",
        function()
          require("mini.pick").builtin.help()
        end,
        desc = "Help",
      },
      {
        "<leader>s/",
        function()
          require("mini.extra").pickers.history({ scope = ":" })
        end,
        desc = "Command History",
      },
      {
        "<leader>gc",
        function()
          require("mini.extra").pickers.git_commits({ path = vim.fn.expand("%") })
        end,
        desc = "Buffer Commits",
      },
      {
        "<leader>gC",
        function()
          require("mini.extra").pickers.git_commits()
        end,
        desc = "Commits",
      },
      {
        "<leader>bb",
        function()
          require("mini.pick").builtin.buffers()
        end,
        desc = "List buffers",
      },
    },
    config = function()
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

      require("mini.move").setup({
        mappings = {
          -- Move visual selection in Visual mode.
          left = "<C-M-h>",
          right = "<C-M-l>",
          down = "<C-M-j>",
          up = "<C-M-k>",

          -- Move current line in Normal mode
          line_left = "<C-M-h>",
          line_right = "<C-M-l>",
          line_down = "<C-M-j>",
          line_up = "<C-M-k>",
        },
      })

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

      if not vim.g.vscode then
        local pick_total_width = 0.8
        local pick_split = 0.6

        local pick = require("mini.pick")

        pick.setup({
          source = {
            show = pick_utils.short_show,
          },
          mappings = {
            send_to_qflist = {
              char = "<C-q>",
              func = pick_utils.send_to_qflist,
            },
            caret_left = "<Left>",
            caret_right = "<Right>",

            choose = "<CR>",
            choose_in_split = "<C-s>",
            choose_in_tabpage = "<C-t>",
            choose_in_vsplit = "<C-v>",
            choose_marked = "<C-CR>",

            delete_char = "<BS>",
            delete_char_right = "<S-BS>",
            delete_left = "<A-BS>",
            delete_word = "<C-w>",

            mark = "<C-x>",
            mark_all = "<C-a>",

            move_start = "<C-g>",
            move_down = "<C-n>",
            move_up = "<C-p>",

            paste = "<C-r>",
            sys_paste = {
              char = "<A-p>",
              func = function()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-r>+", true, true, true), "n", true)
              end,
            },

            refine = "<C-Space>",
            refine_marked = "<M-Space>",

            scroll_up = "<C-u>",
            scroll_down = "<C-d>",
            scroll_left = "<C-h>",
            scroll_right = "<C-l>",

            stop = "<Esc>",

            toggle_info = "<S-Tab>",
            toggle_preview = "<Tab>",
          },
          options = {
            use_cache = true,
          },
          window = {
            config = function()
              local height = math.floor(0.4 * vim.o.lines)
              local total_w = math.floor(pick_total_width * vim.o.columns)
              local results_w = math.floor(pick_split * total_w)
              return {
                anchor = "SE",
                col = vim.o.columns,
                height = height,
                row = vim.o.lines,
                width = results_w,
                border = "single",
              }
            end,
          },
        })

        require("mini.extra").setup()

        pick_utils.setup_grep_trim(pick)
        pick_utils.setup_preview(pick, pick_total_width, pick_split)

        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(args)
            pick_utils.lsp_keymaps(args.buf)
          end,
        })

        require("mini.icons").setup()
        require("mini.icons").mock_nvim_web_devicons()

        clue_utils.ai_whichkey()
      end
    end,
  },
}
