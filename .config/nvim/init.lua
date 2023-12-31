local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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
    "luukvbaal/nnn.nvim",
    "andweeb/presence.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-telescope/telescope-frecency.nvim",
    'nvim-tree/nvim-web-devicons',
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    { 'VonHeikemen/lsp-zero.nvim', branch = 'v3.x' },
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/nvim-cmp' },
    { 'L3MON4D3/LuaSnip' },
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "tpope/vim-commentary",
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            signs = true,
            sign_priority = 50,
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    },
    "numToStr/FTerm.nvim",
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },
    "tpope/vim-fugitive",
    'vim-airline/vim-airline',
    'airblade/vim-gitgutter',
    'f-person/git-blame.nvim',
    'mg979/vim-visual-multi',
    'nmac427/guess-indent.nvim',
    'windwp/nvim-autopairs',
}, opts)

require("nvim-web-devicons").setup()

require("nnn").setup({
})

require("presence").setup({})

require 'nvim-treesitter.configs'.setup {
    ensure_installed = {
        "typescript",
        "svelte",
        "lua",
        "php",
        "javascript",
        "css",
        "html",
        "rust",
        "sql",
        "regex",
    },
    highlight = {
        enable = true,
        disable = {},
    },
}

local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({ buffer = bufnr })
end)

require('lspconfig').intelephense.setup({
})

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        'intelephense',
        'lua_ls',
        'vimls',
        'rust_analyzer',
        'volar',
        'svelte',
        'tsserver',
        'tailwindcss',
    },
    handlers = {
        lsp_zero.default_setup,
    },
})

local cmp = require('cmp')

cmp.setup({
    preselect = 'item',
    completion = {
        completeopt = 'menu,menuone,noinsert'
    },
    mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp.mapping.confirm({ select = true }),
        -- TODO: figure this out
        -- ['<S-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c' })
    })
})


local fterm = require('FTerm')
fterm.setup({})

vim.cmd [[colorscheme tokyonight]]


-- Keymappings
require("telescope").load_extension "frecency"
local telescope = require("telescope.builtin")

vim.g.mapleader = " "
vim.api.nvim_set_keymap('n', '<Leader>fm', ':NnnExplorer<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ff', telescope.find_files, {})
vim.keymap.set('n', '<leader>fg', function()
    telescope.live_grep({
        find_command = { 'git', 'ls-files', '--exclude-standard' }
    })
end, {})
vim.keymap.set('n', '<leader>fs', telescope.treesitter)
vim.api.nvim_set_keymap('n', '<leader>fr', ':Telescope frecency<CR>', { noremap = true, silent = true})
vim.keymap.set('n', '<leader>fa', telescope.builtin)

vim.api.nvim_set_keymap('n', '<leader>wj', ':wincmd j<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>Wj', '<C-w>s:wincmd j<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>wk', ':wincmd k<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>Wk', '<C-w>s', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>wh', ':wincmd h<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>Wh', '<C-w>v', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>wl', ':wincmd l<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>Wl', '<C-w>v:wincmd l<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>tf', fterm.toggle, {})
vim.keymap.set('t', '<leader>tf', fterm.toggle, {})

vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>lr', ':LspRestart<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>li', ':LspInfo<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<S-Space>', function() cmp.mapping(cmp.mapping.complete(), {'i', 'c'}) end)

local rel = true
vim.keymap.set('n', '<leader>~', function()
    vim.opt.relativenumber = not rel
    rel = not rel
end)

vim.keymap.set('n', '<leader>yn', ':let @" = expand("%")\n', { noremap = true, silent = true })

-- General Vim options
vim.opt.list = true;
vim.opt.expandtab = true;
vim.opt.listchars = 'tab:>-,space:·';
vim.opt.colorcolumn = '80';
vim.opt.tabstop = 4;
vim.opt.shiftwidth = 4;
vim.opt.expandtab = true;
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.scrolloff = 5
require('guess-indent').setup {}
require('nvim-autopairs').setup {}

-- Line number colors
vim.cmd [[
    highlight LineNr ctermfg=White guifg=White
]]
