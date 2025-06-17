return {
  "3rd/image.nvim",
  enabled = false,
  event = "VeryLazy",
  vscode = false,
  opts = {
    backend = "kitty",
    processor = "magick_cli", -- "magick_cli" or "magick_rock"
    integrations = {
      markdown = {
        enabled = false,
        clear_in_insert_mode = true,
        download_remote_images = true,
        filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
      },
      neorg = {
        enabled = false,
        filetypes = { "norg" },
      },
      typst = {
        enabled = false,
        only_render_image_at_cursor = true,
        filetypes = { "typst" },
      },
      html = {
        enabled = false,
      },
      css = {
        enabled = false,
      },
    },
    max_width = nil,
    max_height = nil,
    max_width_window_percentage = 100,
    max_height_window_percentage = 50,
    window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
    window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign" },
    editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
    tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
  },
}
