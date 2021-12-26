-- Option list
-- https://github.com/neovim/neovim/blob/master/src/nvim/options.lua

-- Global options
local o = vim.o
o.magic = true
o.showmatch = true
o.smartcase = true
o.undodir = os.getenv('HOME') .. '/.vim-undo'
o.hlsearch = true
o.ignorecase = true
o.incsearch = true
o.showcmd = true
o.ttyfast = true
o.termguicolors = true
o.showtabline = 1
o.backup = false
o.smarttab = true
o.background = 'dark'
o.clipboard = 'unnamedplus'
o.lazyredraw = true
o.mouse = 'a'

-- Window options
local wo = vim.wo
wo.number = true
wo.wrap = true
wo.cursorline = true

-- Buffer options
local bo = vim.bo
bo.autoread = true
bo.swapfile = false
bo.expandtab = true
bo.shiftwidth = 4
bo.tabstop = 4
bo.syntax = 'on'
bo.fileencoding = 'UTF-8'
bo.autoindent = true
bo.autoindent = true
bo.swapfile = false
bo.undofile = true
-- Keep undo history across sessions by storing it in a file
if not (vim.fn.empty(vim.fn.glob(o.undodir)) > 0) then
  os.execute('mkdir -p' .. o.undodir .. '-m=0770')
end

-- Vim commands
local cmd = vim.api.nvim_command
cmd('filetype plugin indent on')
cmd('colorscheme dogrun')
cmd('autocmd ColorScheme * highlight Normal guibg=NONE ctermbg=NONE')
-- Return to last edit position when opening files
cmd([[autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]])

-- Remaps
local keymap = vim.api.nvim_set_keymap
keymap('t', '<Esc>', [[<C-\><C-n>]], {})

