local wezterm = require('wezterm')
local gpu_adapters = require('utils.gpu_adapter')
local tabline = wezterm.plugin.require('https://github.com/michaelbrusegard/tabline.wez')

return {
   animation_fps = 60,
   max_fps = 60,
   front_end = 'WebGpu',
   webgpu_power_preference = 'HighPerformance',
   webgpu_preferred_adapter = gpu_adapters:pick_best(),
   color_scheme = 'kanagawa-paper',
   -- background
   background = {
      {
         source = { Color = '#16161D' },
         height = '100%',
         width = '100%',
         opacity = 0.95,
      },
   },
   -- scrollbar
   enable_scroll_bar = true,

   -- tab bar
   enable_tab_bar = true,
   hide_tab_bar_if_only_one_tab = false,
   use_fancy_tab_bar = true,
   tab_max_width = 25,
   show_tab_index_in_tab_bar = false,
   switch_to_last_active_tab_when_closing_tab = true,

   -- window
   window_padding = {
      left = 10,
      right = 10,
      top = 12,
      bottom = 7,
   },
   window_close_confirmation = 'NeverPrompt',
   window_frame = {
      active_titlebar_bg = '#090909',
      -- font = fonts.font,
      -- font_size = fonts.font_size,
   },
   inactive_pane_hsb = {
      saturation = 0.9,
      brightness = 0.65,
   },
   tabline.setup({
      options = {
         icons_enabled = true,
         tabs_enabled = true,
         theme_overrides = {},
         section_separators = {
            left = wezterm.nerdfonts.pl_left_hard_divider,
            right = wezterm.nerdfonts.pl_right_hard_divider,
         },
         component_separators = {
            left = wezterm.nerdfonts.pl_left_soft_divider,
            right = wezterm.nerdfonts.pl_right_soft_divider,
         },
         tab_separators = {
            left = wezterm.nerdfonts.pl_left_hard_divider,
            right = wezterm.nerdfonts.pl_right_hard_divider,
         },
         color_overrides = {
            normal_mode = {
               a = { fg = '#282834', bg = '#c4b28a' },
               b = { fg = '#c4b28a', bg = '#353545' },
               c = { fg = '#696861', bg = '#282834' },
            },
            copy_mode = {
               a = { fg = '#282834', bg = '#87a987' },
               b = { fg = '#87a987', bg = '#353545' },
               c = { fg = '#696861', bg = '#282834' },
            },
            search_mode = {
               a = { fg = '#282834', bg = '#938AA9' },
               b = { fg = '#938AA9', bg = '#353545' },
               c = { fg = '#696861', bg = '#282834' },
            },
            window_mode = {
               a = { fg = '#282834', bg = '#658594' },
               b = { fg = '#658594', bg = '#353545' },
               c = { fg = '#696861', bg = '#282834' },
            },
            resize_mode = {
               a = { fg = '#282834', bg = '#c4746e' },
               b = { fg = '#c4746e', bg = '#353545' },
               c = { fg = '#696861', bg = '#282834' },
            },
            tab = {
               active = { fg = '#c4b28a', bg = '#353545' },
               inactive = { fg = '#696861', bg = '#282834' },
               inactive_hover = { fg = '#c4b28a', bg = '#353545' },
            },
         },
      },
      sections = {
         tabline_a = { 'mode' },
         tabline_b = { 'workspace' },
         tabline_c = { ' ' },
         tab_active = {
            'index',
            { 'parent', padding = 0 },
            '/',
            { 'cwd', padding = { left = 0, right = 1 } },
            { 'zoomed', padding = 0 },
         },
         tab_inactive = { 'index', { 'process', padding = { left = 0, right = 1 } } },
         tabline_x = { 'ram', 'cpu' },
         tabline_y = { 'datetime', 'battery' },
         tabline_z = { 'domain' },
      },
      extensions = {},
   }),
}
