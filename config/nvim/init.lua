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
keymap('n', [[<C-g>]], [[<cmd>lua require('telescope.builtin').find_files()<cr>]], {})
keymap('n', [[<C-f>]], [[<cmd>lua require('telescope.builtin').live_grep()<cr>]], {})

-- LSP settings
local lspconfig = require('lspconfig')

local on_attach = function(client, bufnr)
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
    buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end
lspconfig.rust_analyzer.setup { on_attach = on_attach }
