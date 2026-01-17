return {
  {
    "nvim-tree/nvim-tree.lua",
    event = "VeryLazy",
    cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },
      { "<leader>E", "<cmd>NvimTreeFindFile<cr>", desc = "Explorer (reveal file)" },
    },
    opts = {
      disable_netrw = true,
      hijack_netrw = true,

      view = {
        width = 35,
        preserve_window_proportions = true,
        number = false,
        relativenumber = false,
        signcolumn = "yes",
      },

      -- Better default behavior + smoother navigation.
      hijack_cursor = true,
      sync_root_with_cwd = true,
      respect_buf_cwd = true,

      renderer = {
        root_folder_label = false,
        highlight_git = true,
        highlight_diagnostics = true,
        highlight_opened_files = "name",

        indent_markers = {
          enable = true,
          inline_arrows = true,
        },

        icons = {
          web_devicons = {
            file = {
              enable = true,
              color = true,
            },
            folder = {
              enable = true,
              color = true,
            },
          },
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
            diagnostics = true,
          },
          glyphs = {
            default = "",
            symlink = "",
            bookmark = "󰆤",
            folder = {
              arrow_closed = "",
              arrow_open = "",
              default = "",
              open = "",
              empty = "",
              empty_open = "",
              symlink = "",
              symlink_open = "",
            },
            git = {
              unstaged = "",
              staged = "✓",
              unmerged = "",
              renamed = "➜",
              untracked = "★",
              deleted = "",
              ignored = "◌",
            },
          },
        },

        special_files = { "README.md", "readme.md", "Makefile", "MAKEFILE", "pyproject.toml" },
      },

      update_focused_file = {
        enable = true,
        update_root = false,
        ignore_list = {},
      },

      diagnostics = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
        icons = {
          hint = "󰌶",
          info = "󰋽",
          warning = "󰀪",
          error = "󰅚",
        },
      },

      git = {
        enable = true,
        ignore = false,
        timeout = 500,
      },

      filters = {
        dotfiles = false,
        git_ignored = false,
      },

      actions = {
        open_file = {
          quit_on_open = false,
          resize_window = true,
          window_picker = {
            enable = true,
          },
        },
        change_dir = {
          enable = true,
          global = true,
          restrict_above_cwd = true,
        },
      },

      ui = {
        confirm = {
          remove = true,
          trash = true,
        },
      },
    },
  },
}
