-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- This file is automatically loaded by lazyvim.config.init

-- DO NOT USE `LazyVim.safe_keymap_set` IN YOUR OWN CONFIG!!
-- use `vim.keymap.set` instead
-- local map = LazyVim.safe_keymap_set
local map = vim.keymap.set
vim.g.mapleader = ' '

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- Buffers
--
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<C-x>", function()
    local buf = vim.api.nvim_get_current_buf()
    if vim.bo.buftype == '' then -- Only delete file buffers
        if vim.bo[buf].modified then
            vim.notify("Warning: Buffer has unsaved changes!", vim.log.levels.WARN, { title = "Buffer Delete" })
            return
        end
        vim.cmd('bp')         -- Switch to previous buffer first
        vim.cmd('bd ' .. buf) -- Force delete
    else
        vim.cmd('bd!')        -- Force delete special buffers
    end
end, { desc = "Delete Buffer (Keeping Window)" })

map("n", "<C-S-x>", function()
    local buf = vim.api.nvim_get_current_buf()
    if vim.bo.buftype == '' then -- Only delete file buffers
        vim.cmd('bp')            -- Switch to previous buffer first
        vim.cmd('bd! ' .. buf)   -- Force delete
    else
        vim.cmd('bd!')           -- Force delete special buffers
    end
end, { desc = "Force Delete Buffer (Keeping Window)" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Windows
map("n", "<leader>-", "<cmd>split<cr>", { desc = "Split Window Below" })
map("n", "<leader>|", "<cmd>vsplit<cr>", { desc = "Split Window Right" })
map("n", "<leader>wd", "<cmd>close<cr>", { desc = "Delete Window" })
map("n", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
map("n", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
map("n", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
map("n", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })

-- NeoTree

map("n", "<leader>n", "<cmd>Neotree toggle position=float<cr>", { desc = "Toggle NeoTree", remap = true })

-- Emmet

map({ "n", "v" }, '<leader>xe', require('nvim-emmet').wrap_with_abbreviation)

-- Telescope

local builtin = require('telescope.builtin')
map('n', '<leader>tf', builtin.find_files, { desc = 'Telescope Find Files' })
map('n', '<leader>tg', builtin.live_grep, { desc = 'Telescope Live Grep' })
map('n', '<leader>tb', builtin.buffers, { desc = 'Telescope Buffers' })
map('n', '<leader>th', builtin.help_tags, { desc = 'Telescope Help Tags' })

-- TreeSitter

map('n', '<leader>tp', ":TSPlaygroundToggle<CR>", { desc = 'Telescope Help Tags' })

-- Goto Navigation

map('n', 'gd', '<cmd>Telescope lsp_definitions<cr>', { desc = 'Goto Definition (Telescope)' }) -- Prefer over plain `gd`
map('n', 'gr', '<cmd>Telescope lsp_references<cr>', { desc = 'Goto References (Telescope)' })
map('n', 'gi', vim.lsp.buf.implementation, { desc = 'Goto Implementation' })

-- Code Help

map('n', 'K', vim.lsp.buf.hover, { desc = 'Hover Documentation' })

-- Code Modifications

map('n', '<space>rn', vim.lsp.buf.rename, { desc = 'Rename Symbol' })
map('n', '<space>ca', vim.lsp.buf.code_action, { desc = 'Code Action' })
map('n', '<space>f', function()
    vim.lsp.buf.format({ async = true })
end, { desc = 'Format Buffer' })

-- Debugging

local function debugging()
    local dap = require('dap');
    map('n', '<F5>', function()
        dap.continue()
    end, { noremap = true })
    map('n', '<F6>', function()
        dap.step_out()
    end, { noremap = true })
    map('n', '<F7>', function()
        dap.step_over()
        -- dap.step_over({ steppingGranularity = 'statement' })
    end, { noremap = true })
    map('n', '<F8>', function()
        dap.step_into()
        -- dap.step_into({ steppingGranularity = 'statement' })
    end, { noremap = true })
    map('n', '<Leader>b', ":DapToggleBreakpoint<CR>", { noremap = true })
    map('n', '<Leader>dr', ":DapToggleRepl<CR>", { noremap = true })
    map('n', '<Leader>dt', function()
        require('dapui').toggle()
    end)
end

debugging()
