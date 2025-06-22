require('mason').setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

-- Only install essential LSPs
require('mason-lspconfig').setup({
    ensure_installed = {
        'pylsp',         -- Python
        'clangd',        -- C/C++
        'cmake',         -- CMake
        'cssls',         -- CSS
        'lua_ls',        -- Lua
        'ts_ls',         -- JavaScript/TypeScript
        'rust_analyzer', -- Rust
        'html',          -- HTML
        'emmet_ls',      -- Emmet
        'omnisharp',     -- C#
        'jsonls',        -- JSON
    },
    automatic_installation = true
})

-- Enable diagnostics with your existing config
vim.diagnostic.config(require("diagnostics"))

-- Lazy-load LSPs on file open
local lspconfig = require('lspconfig')
local on_attach = function(client, bufnr)
    -- Your existing on_attach logic here (if any)
end

-- Default capabilities with snippets support
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Configure each LSP (minimal setups, add customizations as needed)
lspconfig.pylsp.setup({ on_attach = on_attach, capabilities = capabilities })
lspconfig.clangd.setup({ on_attach = on_attach, capabilities = capabilities })
lspconfig.cmake.setup({ on_attach = on_attach, capabilities = capabilities })
lspconfig.cssls.setup({ on_attach = on_attach, capabilities = capabilities })
lspconfig.lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = {
                globals = {
                    -- List all global variables the game provides
                    "vim",
                },
            },
            workspace = {
                -- Point to your type definitions
                library = {
                    vim.api.nvim_get_runtime_file("", true),
                    -- Add path to your type definitions
                    "/path/to/your/project/types",
                },
                checkThirdParty = false,
            },
        }
    }
})
lspconfig.ts_ls.setup({ on_attach = on_attach, capabilities = capabilities })
lspconfig.rust_analyzer.setup({ on_attach = on_attach, capabilities = capabilities })
lspconfig.html.setup({ on_attach = on_attach, capabilities = capabilities })
lspconfig.jsonls.setup({ on_attach = on_attach, capabilities = capabilities })

-- C#: Omnisharp (only loaded for .cs files)
lspconfig.omnisharp.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "/usr/local/bin/omnisharp/OmniSharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
    filetypes = { "cs" },
    root_dir = function(fname)
        return lspconfig.util.root_pattern("*.csproj", "*.sln")(fname) or vim.loop.cwd()
    end,
    -- Keep your existing Omnisharp settings
    settings = {
        FormattingOptions = {
            EnableEditorConfigSupport = true,
            OrganizeImports = nil,
        },
        MsBuild = {
            LoadProjectsOnDemand = nil,
        },
        RoslynExtensionsOptions = {
            EnableAnalyzersSupport = nil,
            EnableImportCompletion = nil,
            AnalyzeOpenDocumentsOnly = nil,
        },
        Sdk = {
            IncludePrereleases = true,
        },
    }
})

-- Emmet (only for web files)
lspconfig.emmet_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "html", "css", "scss", "javascriptreact", "typescriptreact" },
    init_options = {
        showAbbreviationSuggestions = true,
        showExpandedAbbreviation = "always",
        showSuggestionsAsSnippets = false,
    }
})
