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
    'andweeb/presence.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-tree/nvim-web-devicons',
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/nvim-cmp',
    'neovim/nvim-lspconfig',
    'tpope/vim-commentary',
    'tpope/vim-fugitive',
    'vim-airline/vim-airline',
    'airblade/vim-gitgutter',
    'f-person/git-blame.nvim',
    'nmac427/guess-indent.nvim',
    'windwp/nvim-autopairs',
    'L3MON4D3/LuaSnip',
    {
        'folke/todo-comments.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {
            signs = true,
            sign_priority = 50,
        }
    },
    {
        'folke/tokyonight.nvim',
        lazy = false,
        priority = 1000,
        opts = {},
    },
    {
        'glacambre/firenvim',

        -- Lazy load firenvim
        -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
        lazy = not vim.g.started_by_firenvim,
        -- lazy = false,
        build = function()
            vim.fn['firenvim#install'](0)
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


-- note: diagnostics are not exclusive to lsp servers
-- so these can be global keybindings
vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = { buffer = event.buf }

        -- these will be buffer-local keybindings
        -- because they only work if you have an active language server

        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    end
})

require('lspconfig').intelephense.setup({})
require('lspconfig').rust_analyzer.setup({})
require('lspconfig').gopls.setup({})
require('lspconfig').tsserver.setup({})

require('lspconfig').lua_ls.setup({})
require('lspconfig').vimls.setup({})
require('lspconfig').volar.setup({})
require('lspconfig').svelte.setup({})
require('lspconfig').tailwindcss.setup({})

-- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    -- ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
  }, {
    { name = 'buffer' },
    { name = 'path' }
  })
})

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
vim.keymap.set('n', '<leader>ff', telescope.find_files, {})
vim.keymap.set('n', '<leader>fg', function()
    telescope.live_grep({
        find_command = { 'git', 'ls-files', '--exclude-standard' }
    })
end, {})
vim.keymap.set('n', '<leader>fs', telescope.treesitter)
vim.keymap.set('n', '<leader>fa', telescope.builtin)

vim.api.nvim_set_keymap('n', '<leader>w', '<C-w>', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>lr', ':LspRestart<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>li', ':LspInfo<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<S-Space>', function() cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }) end)

vim.keymap.set('n', '<leader>bs', ':w<CR>:call firenvim#press_keys("<LT>CR>")<CR>ggdGa')
vim.keymap.set('n', '<leader>be', ':call firenvim#focus_page()<CR>')

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
