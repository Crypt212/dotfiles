local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- Emmet
    {
        'olrtg/nvim-emmet',
    },

    -- Melange Colorscheme
    { "savq/melange-nvim" },

    -- TokyoNight Colorscheme
    { "folke/tokyonight.nvim" },

    -- Debug Adapter Protocol
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
        },
        config = function()
            require("config.nvim-dap")
        end,
    },

    -- Buffer Line
    {
        'akinsho/bufferline.nvim',
        version = "*",
        config = function()
            require("config.bufferline")
        end,
        dependencies = 'nvim-tree/nvim-web-devicons'
    },

    -- TreeSitters
    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require("config.nvim-treesitter")
        end,
    },

    -- Colors
    {
        'uga-rosa/ccc.nvim',
        config = function()
            require("config.ccc")
        end,
    },

    -- Vscode-like pictograms
    {
        "onsails/lspkind.nvim",
        event = { "vimEnter" },
    },

    -- Auto-completion engine
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "lspkind.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
        },
        config = function()
            require("config.nvim-cmp")
        end,
    },

    -- Code snippet engine
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
    },

    -- LSP manager
    {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
    },

    -- NeoTree
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        lazy = true,     -- Changed from false
        cmd = "Neotree", -- Load only when command is called
        config = function()
            require("config.neo-tree")
        end,
    },

    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require("config.telescope")
        end,
    },

    -- Dotnvim
    {
        "adamkali/dotnvim"
    },

    -- Codeium AI
    {
        "Exafunction/windsurf.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
            "Exafunction/codeium.nvim",
        },
        config = function()
            require("codeium").setup({}) -- Basic setup (required)
        end,
    },
})
