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
    { 'olrtg/nvim-emmet', },

    -- Melange Colorscheme
    { "savq/melange-nvim" },

    -- Debug Adapter Protocol
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "theHamsta/nvim-dap-virtual-text",
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "nvim-telescope/telescope-dap.nvim",
            "mxsdev/nvim-dap-vscode-js",
            "microsoft/vscode-js-debug",
        },
        config = function()
            require("config.dap")
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

    -- TreeSitter
    {
        "nvim-treesitter/nvim-treesitter",
        "nvim-treesitter/playground",
        config = function()
            require("config.nvim-treesitter")
        end,
    },

    -- Git Signs
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("config.gitsigns");
        end
    },

    -- Color Picker
    {
        'uga-rosa/ccc.nvim',
        config = function()
            require("config.ccc")
        end,
    },

    -- Auto-completion engine
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "onsails/lspkind.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
        },
        config = function()
            require("lspkind").init({
                symbol_map = {
                    Codeium = "", -- Custom icon for Codeium
                },
            })
            require("luasnip.loaders.from_vscode").lazy_load()
            require("config.nvim-cmp")
        end,
    },

    -- LSP manager
    {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "ray-x/lsp_signature.nvim",
        "neovim/nvim-lspconfig",
        config = function()
            require("lsp")
        end,
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

    -- Render markdown links in popup
    {
        "folke/noice.nvim",
        -- event = "VeryLazy",
        opts = {
            lsp = {
                hover = {
                    enabled = true,
                    silent = false, -- Disable auto-close
                },
            },
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify",
        },
        config = function()
            require("config.noice")
        end
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
