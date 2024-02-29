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
    "andweeb/presence.nvim",
    "nvim-telescope/telescope.nvim",
    'nvim-tree/nvim-web-devicons',
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    { 'VonHeikemen/lsp-zero.nvim', branch = 'v3.x' },
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/nvim-cmp' },
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
    'nmac427/guess-indent.nvim',
    'windwp/nvim-autopairs',
    {
        'glacambre/firenvim',

        -- Lazy load firenvim
        -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
        lazy = not vim.g.started_by_firenvim,
        -- lazy = false,
        build = function()
            vim.fn["firenvim#install"](0)
        end
    },
}, opts)

require("nvim-web-devicons").setup()

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

require('lspconfig').rust_analyzer.setup({})


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

vim.cmd [[
  au ColorScheme * hi Normal ctermbg=none guibg=none
  au ColorScheme * hi SignColumn ctermbg=none
  au ColorScheme * hi NormalNC ctermbg=none guibg=none
  au ColorScheme * hi MsgArea ctermbg=none guibg=none
  au ColorScheme * hi TelescopeBorder ctermbg=none guibg=none
  au ColorScheme * hi NvimTreeNormal ctermbg=none guibg=none
  colorscheme tokyonight
]]
-- Keymappings
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
vim.keymap.set('n', '<leader>fa', telescope.builtin)

vim.api.nvim_set_keymap('n', '<leader>w', '<C-w>', {noremap = true, silent = true})

vim.keymap.set('n', '<leader>tf', fterm.toggle, {})
vim.keymap.set('t', '<leader>tf', fterm.toggle, {})

vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>lr', ':LspRestart<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>li', ':LspInfo<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<S-Space>', function() cmp.mapping(cmp.mapping.complete(), {'i', 'c'}) end)

vim.keymap.set('n', '<leader>bs',':w<CR>:call firenvim#press_keys("<LT>CR>")<CR>ggdGa')
vim.keymap.set('n', '<leader>be',':call firenvim#focus_page()<CR>')

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
