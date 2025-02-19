return {
  {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_wrap_output = true
      vim.keymap.set(
        "n",
        "<localleader>mi",
        ":MoltenInit<CR>",
        { silent = true, desc = "Molten - Initialize the plugin" }
      )
      vim.keymap.set(
        "n",
        "<localleader>mw",
        ":MoltenEvaluateOperator<CR>",
        { silent = true, desc = "Molten - Run operator selection" }
      )
      vim.keymap.set(
        "n",
        "<localleader>me",
        ":MoltenEvaluateLine<CR>",
        { silent = true, desc = "Molten - Evaluate line" }
      )
      vim.keymap.set(
        "n",
        "<localleader>mr",
        ":MoltenReevaluateCell<CR>",
        { silent = true, desc = "Molten - Re-evaluate cell" }
      )
      vim.keymap.set(
        "v",
        "<localleader>me",
        ":<C-u>MoltenEvaluateVisual<CR>gv",
        { silent = true, desc = "Molten - Evaluate visual selection" }
      )
      vim.keymap.set("n", "<localleader>md", ":MoltenDelete<CR>", { silent = true, desc = "Molten - Delete cell" })
      vim.keymap.set("n", "<localleader>mh", ":MoltenHideOutput<CR>", { silent = true, desc = "Molten - Hide output" })
      vim.keymap.set(
        "n",
        "<localleader>ms",
        ":noautocmd MoltenEnterOutput<CR>",
        { silent = true, desc = "Molten - Show/enter output" }
      )
      vim.keymap.set(
        "n",
        "<localleader>mn",
        ":noautocmd MoltenNext<CR>",
        { silent = true, desc = "Molten - Go to Next Cell" }
      )
      vim.keymap.set(
        "n",
        "<localleader>mN",
        ":noautocmd MoltenNext<CR>",
        { silent = true, desc = "Molten - Go to Previous Cell" }
      )
    end,
  },
}
