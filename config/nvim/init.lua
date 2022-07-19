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
o.completeopt = 'menuone,noselect'
o.grepprg = "rg --vimgrep"
o.grepformat = "%f:%l:%c:%M"

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
cmd('highlight Normal guibg=NONE ctermbg=NONE')
-- Return to last edit position when opening files
cmd([[autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]])

-- Remaps
local keymap = vim.api.nvim_set_keymap
keymap('t', '<Esc>', [[<C-\><C-n>]], {})
keymap('n', [[<C-g>]], [[<cmd>lua require('telescope.builtin').find_files()<cr>]], {})
keymap('n', [[<C-f>]], [[<cmd>lua require('telescope.builtin').live_grep()<cr>]], {})

-- Telescope
require('telescope').setup{
    defaults = {
        -- ...
    },
    pickers = {
        find_files = {
            theme = "ivy",
        },
        live_grep = {
            theme = "ivy",
        },
    },
    extensions = {
        -- ...
    }
}

-- Gitsigns
require('gitsigns').setup()

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

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end

    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd!
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
    end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
local servers = { "rust_analyzer", "rnix" }
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup { capabilities = capabilities, on_attach = on_attach }
end

-- Whichkey
local wk = require("which-key")
wk.register({ }, { })

-- cmp setup
local cmp = require 'cmp'
cmp.setup {
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
  },
}

-- Treesitter
require'nvim-treesitter.configs'.setup {
  -- One of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = { }, -- Get them with Nix.

  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to ignore installing
  ignore_install = { },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- list of language that will be disabled
    disable = { },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
