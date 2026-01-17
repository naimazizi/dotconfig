return {
  "NickvanDyke/opencode.nvim",
  event = "VeryLazy",
  vscode = false,
  dependencies = {
    { "akinsho/toggleterm.nvim" },
  },
  config = function()
    local Terminal = require("toggleterm.terminal").Terminal

    local width_ratio = 0.9
    local height_ratio = 0.9

    local opencode_term = Terminal:new({
      cmd = "opencode --port 8899",
      display_name = "opencode",
      direction = "float",
      hidden = false,
      float_opts = {
        border = "curved",
        width = math.floor(vim.o.columns * width_ratio),
        height = math.floor(vim.o.lines * height_ratio),
        row = math.floor((vim.o.lines - (vim.o.lines * height_ratio)) / 2),
        col = math.floor((vim.o.columns - (vim.o.columns * width_ratio)) / 2),
      },
    })
    vim.g.opencode_opts = {
      provider = {
        start = function()
          if not opencode_term:is_open() then
            opencode_term:spawn()
          end
        end,

        toggle = function()
          opencode_term:toggle()
        end,

        show = function()
          if not opencode_term:is_open() then
            opencode_term:open()
          else
            opencode_term:focus()
          end
        end,
      },
    }

    vim.o.autoread = true

    vim.keymap.set({ "n", "x" }, "<leader>aa", function()
      require("opencode").ask("@this: ", { submit = true })
    end, { desc = "Ask opencode" })
    vim.keymap.set({ "n", "x" }, "<leader>ax", function()
      require("opencode").select()
    end, { desc = "Execute opencode action…" })
    vim.keymap.set({ "n", "x" }, "<leader>as", function()
      require("opencode").prompt("@this")
    end, { desc = "Add to opencode" })
    vim.keymap.set({ "n", "t" }, "<c-.>", function()
      require("opencode").toggle()
    end, { desc = "Toggle opencode" })
  end,
}
