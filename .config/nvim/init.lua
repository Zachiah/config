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
}, opts)

require("nnn").setup({
	replace_netrw = "picker",
})
require("presence").setup({})
local telescope = require("telescope.builtin")

-- Set relative line numbers
vim.wo.relativenumber = true
vim.wo.number = true

-- Keymappings
vim.g.mapleader = " "
vim.api.nvim_set_keymap('n', '<Leader>fm', ':NnnExplorer<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ff', telescope.find_files, {})
vim.keymap.set('n', '<leader>fg', telescope.live_grep, {})
vim.api.nvim_set_keymap('n', '<leader>r', ':luafile ' .. vim.fn.stdpath('config') .. '/init.lua<CR>', { noremap = true, silent = true })
