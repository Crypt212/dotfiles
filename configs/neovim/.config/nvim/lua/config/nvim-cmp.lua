local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require("cmp")
local luasnip = require("luasnip") -- Add this line

cmp.setup({
    source_priority = {
        codeium = 1000,
        nvim_lsp = 900,
        luasnip = 800,
        buffer = 700,
        path = 600,
    },
    window = {
        completion = {
            border = "rounded",
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel",
        },
        -- documentation = {
        --     border = "rounded",
        --     winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
        -- },
    },
    opts = {
        -- documentation = {
        --     border = "rounded", -- or "single", "double", "shadow"
        --     -- Highlight and make URLs clickable
        --     -- winhighlight = "NormalFloat:Pmenu,Normal:Pmenu,CursorLine:PmenuSel,FloatBorder:FloatBorder",
        -- },
        window = {
            completion = { border = "rounded" },
            documentation = { border = "rounded" },
        }
    },
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        -- Use <C-b/f> to scroll the docs
        ['<C-h>'] = cmp.mapping.scroll_docs(-4),
        ['<C-l>'] = cmp.mapping.scroll_docs(4),

        -- Use <C-k/j> to switch in items
        -- ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        -- ['<Tab>'] = cmp.mapping.select_next_item(),

        -- Use <CR>(Enter) to confirm selection
        -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),

        -- A super tab
        ["<C-j>"] = cmp.mapping(function(fallback)
            -- Hint: if the completion menu is visible select next one
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }), -- i - insert mode; s - select mode
        ["<C-k>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    -- Let's configure the item's appearance
    -- source: https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance
    formatting = {
        -- Set order from left to right
        -- kind: single letter indicating the type of completion
        -- abbr: abbreviation of "word"; when not empty it is used in the menu instead of "word"
        -- menu: extra text for the popup menu, displayed after "word" or "abbr"
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            -- Load icons via lspkind (ensure it's installed)
            local lspkind_ok, lspkind = pcall(require, "lspkind")
            if lspkind_ok then
                vim_item.kind = lspkind.symbolic(vim_item.kind) or vim_item.kind -- Just icons, no text
            end

            local names = {
                codeium = "Codeium",
                nvim_lsp = "LSP",
                luasnip = "Snippet",
                buffer = "Buffer",
                path = "Path",
                nvim_lsp_signature_help = "Help",
            }
            vim_item.menu = ("%s"):format(
                names[entry.source.name] or ""
            )

            -- Safely handle documentation (avoid modifying if nil)
            if vim_item.documentation then
                vim_item.documentation = vim_item.documentation
                    :gsub("(https?://[%w-_%.%?%.:/%+=&]+)", "🔗 %1") -- Strict URL matching
            end

            return vim_item
        end,
    },

    -- Set source precedence
    sources = cmp.config.sources({
        { name = "codeium" },  -- Codeium completions
        { name = 'nvim_lsp' }, -- For nvim-lsp
        { name = "luasnip" },  -- For users of luasnip
        { name = 'buffer' },   -- For buffer word completion
        { name = 'path' },     -- For path completion
    })
})
