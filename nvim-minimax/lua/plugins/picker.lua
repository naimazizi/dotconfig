return {
  {
    'ibhagwan/fzf-lua',
    vscode = false,
    cmd = 'FzfLua',
    opts = function()
      local fzf = require('fzf-lua')
      local actions = require('fzf-lua.actions')

      -- Roughly matches LazyVim's fzf-lua defaults.
      return {
        'telescope',
        winopts = {
          height = 0.85,
          width = 0.85,
          row = 0.35,
          col = 0.50,
          preview = {
            vertical = 'down:45%',
            horizontal = 'right:60%',
            layout = 'flex',
            flip_columns = 120,
          },
        },
        fzf_opts = {
          ['--layout'] = 'reverse',
          ['--info'] = 'inline-right',
          ['--margin'] = '1',
          ['--padding'] = '1',
        },
        files = {
          prompt = 'Files❯ ',
          git_icons = true,
          file_icons = true,
          color_icons = true,
          actions = {
            ['default'] = actions.file_edit,
            ['ctrl-s'] = actions.file_split,
            ['ctrl-v'] = actions.file_vsplit,
            ['ctrl-t'] = actions.file_tabedit,
            ['alt-q'] = actions.file_sel_to_qf,
          },
        },
        grep = {
          prompt = 'Grep❯ ',
          rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -g'!.git/'",
          actions = {
            ['default'] = actions.file_edit,
            ['ctrl-s'] = actions.file_split,
            ['ctrl-v'] = actions.file_vsplit,
            ['ctrl-t'] = actions.file_tabedit,
            ['alt-q'] = actions.file_sel_to_qf,
          },
        },
        buffers = {
          prompt = 'Buffers❯ ',
        },
      }
    end,
  },

  {
    'dmtrKovalenko/fff.nvim',
    vscode = false,
    build = function()
      require('fff.download').download_or_build_binary()
    end,
    opts = {
      prompt = ' ',
      title = 'Find Files',
    },
    lazy = false,
  },
}
