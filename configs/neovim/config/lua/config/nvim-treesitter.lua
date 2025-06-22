require("nvim-treesitter.configs").setup({
    ensure_installed = { "lua", "python", "javascript", "css", "html", "cpp" },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false, -- Critical for performance
    },
    incremental_selection = { enable = false }, -- Disable if unused
    indent = { enable = false },               -- Often causes lag

    fold = {
        enable = true,
        disable = {}, -- Ensure javascript isn't listed here
        -- Additional folding configuration
        fold_virt_text = true,
        default_fold_text = "⏷ %s... %d lines",
    },
})
