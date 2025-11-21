return {
    {
        "vscode-neovim/vscode-multi-cursor.nvim",
        event = "VeryLazy",
        vscode = true,
        opts = {
            -- Whether to set default mappings
            default_mappings = true,
            -- If set to true, only multiple cursors will be created without multiple selections
            no_selection = false,
        },
    },
    {
        "danymat/neogen",
        vscode = true,
    },
}
