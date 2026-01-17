return {
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      preset = 'helix',
      delay = 200,
      icons = {
        mappings = false,
      },
      spec = {
        { '<leader>a', group = 'AI' },
        { '<leader>b', group = 'buffer' },
        { '<leader>c', group = 'code' },
        { '<leader>d', group = 'debug' },
        { '<leader>f', group = 'find' },
        { '<leader>g', group = 'git' },
        { '<leader>q', group = 'quit/session' },
        { '<leader>t', group = 'test' },
        { '<leader>w', group = 'windows' },
      },
    },
  },
}
