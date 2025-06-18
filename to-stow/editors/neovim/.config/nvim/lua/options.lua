local _vim = vim

-- Hint: use `:h <option>` to figure out the meaning if needed
_vim.opt.clipboard = "unnamedplus" -- use system clipboard
_vim.opt.completeopt = { "menu", "menuone", "noselect" }
_vim.opt.mouse = "a"               -- allow the mouse to be used in Nvim

-- Tab
_vim.opt.tabstop = 4      -- number of visual spaces per TAB
_vim.opt.softtabstop = 4  -- number of spacesin tab when editing
_vim.opt.shiftwidth = 4   -- insert 4 spaces on a tab
_vim.opt.expandtab = true -- tabs are spaces, mainly because of python

-- UI config
_vim.opt.number = true         -- show absolute number
_vim.opt.relativenumber = true -- add numbers to each line on the left side
_vim.opt.cursorline = true     -- highlight cursor line underneath the cursor horizontally
_vim.opt.splitbelow = true     -- open new vertical split bottom
_vim.opt.splitright = true     -- open new horizontal splits right

_vim.o.termguicolors = true   -- Fallback to 256 colors
_vim.opt.termguicolors = true  -- enabl 24-bit RGB color in the TUI
_vim.o.background = "dark"     -- Force dark mode
_vim.opt.showmode = false      -- we are experienced, wo don't need the "-- INSERT --" mode hint

_vim.cmd.colorscheme 'melange'

-- Searching
_vim.opt.incsearch = true  -- search as characters are entered
_vim.opt.hlsearch = false  -- do not highlight matches
_vim.opt.ignorecase = true -- ignore case in searches by default
_vim.opt.smartcase = true  -- but make it case sensitive if an uppercase is entered

-- Enable folding with tree-sitter
_vim.opt.foldmethod = "expr"
_vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
_vim.opt.foldtext = [[substitute(getline(v:foldstart), '\t', repeat(' ', &tabstop), 'g').'...'.trim(getline(v:foldend))..' ('.(v:foldend - v:foldstart).' lines)']]
_vim.opt.foldlevel = 99 -- Keep most folds open by default
_vim.opt.foldenable = true

-- Optional: Improve fold appearance
_vim.opt.fillchars = {
    fold = "-" ,     -- " ",
    foldopen = "",
    foldclose = "",
    foldsep = " ",
}

-- Force folding for JavaScript files only
_vim.api.nvim_create_autocmd('FileType', {
	pattern = 'javascript',
	callback = function()
		_vim.opt_local.foldmethod = 'expr'
		_vim.opt_local.foldexpr = 'nvim_treesitter#foldexpr()'
		_vim.opt_local.foldlevel = 99
	end
})
