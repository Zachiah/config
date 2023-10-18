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
}, opts)

require("nnn").setup({
})

require("presence").setup({})
local telescope = require("telescope.builtin")

require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "typescript", "svelte", "lua" }, -- one of "all", "language", or a list of languages
    highlight = {
        enable = true,                                -- false will disable the whole extension
        disable = {},                                 -- list of language that will be disabled
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
    -- Replace the language servers listed here
    -- with the ones you want to install
    ensure_installed = {
        'intelephense',
        'lua_ls',
        'vimls',
        'rust_analyzer',
        'volar',
        'svelte',
        'tsserver',
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
    })
})


local fterm = require('FTerm')
fterm.setup({})

vim.cmd [[colorscheme tokyonight]]

-- Set relative line numbers
vim.wo.relativenumber = true
vim.wo.number = true

-- Keymappings
vim.g.mapleader = " "
vim.api.nvim_set_keymap('n', '<Leader>fm', ':NnnExplorer<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ff', telescope.find_files, {})
vim.keymap.set('n', '<leader>fg', telescope.live_grep, {})

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
vim.keymap.set('n', '<leader>lr', ':LspRestart', { noremap = true, silent = true })

vim.cmd [[
set tabstop=4
set shiftwidth=4
set expandtab
]]
