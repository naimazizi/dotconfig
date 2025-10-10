local wezterm = require('wezterm')
local mux = wezterm.mux

local M = {}

M.setup = function()
   wezterm.on('gui-attached', function(domain)
      -- maximize all displayed windows on startup
      local workspace = mux.get_active_workspace()
      for _, window in ipairs(mux.all_windows()) do
         if window:get_workspace() == workspace then
            -- window:gui_window():maximize()
            window:gui_window():set_position(1025, 500)
            window:gui_window():set_inner_size(2000, 1500)
         end
      end
   end)
end

return M
