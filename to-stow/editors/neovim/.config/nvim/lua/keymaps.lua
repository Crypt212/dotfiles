-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- This file is automatically loaded by lazyvim.config.init

-- DO NOT USE `LazyVim.safe_keymap_set` IN YOUR OWN CONFIG!!
-- use `vim.keymap.set` instead
-- local map = LazyVim.safe_keymap_set
local _vim = vim
local map = _vim.keymap.set
_vim.g.mapleader = ' '

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
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<C-x>", function()
    local buf = _vim.api.nvim_get_current_buf()
    if _vim.bo.buftype == '' then -- Only delete file buffers
        if _vim.bo[buf].modified then
            _vim.notify("Warning: Buffer has unsaved changes!", _vim.log.levels.WARN, { title = "Buffer Delete" })
            return
        end
        _vim.cmd('bp')         -- Switch to previous buffer first
        _vim.cmd('bd ' .. buf) -- Force delete
    else
        _vim.cmd('bd!')        -- Force delete special buffers
    end
end, { desc = "Delete Buffer (Keeping Window)" })

map("n", "<C-S-x>", function()
    local buf = _vim.api.nvim_get_current_buf()
    if _vim.bo.buftype == '' then -- Only delete file buffers
        _vim.cmd('bp')            -- Switch to previous buffer first
        _vim.cmd('bd! ' .. buf)   -- Force delete
    else
        _vim.cmd('bd!')           -- Force delete special buffers
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

-- stylua: ignore start

-- quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- Terminal Mappings
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })

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

-- Codeium

-- map("i", "<Tab>", function() -- Accept suggestion with <C-l> (conflict-free)
--     return _vim.fn["codeium#Accept"]()
-- end, { expr = true, desc = "Codeium: Accept suggestion" })
--
-- map("i", "<S-Tab>", function() -- Manual trigger (alternative to <C-x>)
--     return _vim.fn["codeium#CycleCompletions"](1)
-- end, { expr = true, desc = "Codeium: Next suggestion" })

-- Goto Navigation

map('n', 'gD', _vim.lsp.buf.declaration, { desc = 'Goto Declaration' })
map('n', 'gd', '<cmd>Telescope lsp_definitions<cr>', { desc = 'Goto Definition (Telescope)' }) -- Prefer over plain `gd`
map('n', 'gi', _vim.lsp.buf.implementation, { desc = 'Goto Implementation' })

-- Code Help

map('n', 'K', _vim.lsp.buf.hover, { desc = 'Hover Documentation' })
map('n', '<C-k>', _vim.lsp.buf.signature_help, { desc = 'Signature Help' })

-- References

map('n', 'gr', '<cmd>Telescope lsp_references<cr>', { desc = 'Goto References (Telescope)' })

-- Code Modifications

map('n', '<space>rn', _vim.lsp.buf.rename, { desc = 'Rename Symbol' })
map('n', '<space>ca', _vim.lsp.buf.code_action, { desc = 'Code Action' })
map('n', '<space>f', function()
    _vim.lsp.buf.format({ async = true })
end, { desc = 'Format Buffer' })

-- -- Workspace (Advanced - Only if you use multi-folder projects)
--
-- map('n', '<space>wa', gvim.lsp.buf.add_workspace_folder, { desc = 'Workspace Add Folder' })
-- map('n', '<space>wr', gvim.lsp.buf.remove_workspace_folder, { desc = 'Workspace Remove Folder' })
-- map('n', '<space>wl', function()
--     print(gvim.inspect(gvim.lsp.buf.list_workspace_folders()))
-- end, { desc = 'Workspace List Folders' })
