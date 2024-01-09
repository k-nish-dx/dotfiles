vim.opt.encoding = 'utf-8'
vim.scriptencoding = 'utf-8'

vim.opt.tabstop = 4
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.shiftwidth = 4
vim.opt.colorcolumn = '100'
vim.opt.visualbell = true
vim.opt.number = true
vim.opt.showmatch = true
vim.opt.matchtime = 1
vim.opt.clipboard = 'unnamedplus'
vim.opt.spelllang = 'en_us'

-- mapleader
vim.g.mapleader = ","
vim.keymap.set("n", "<leader>v", vim.cmd.Ex)
-- basic keymap for US keyboard
vim.keymap.set({'n', 'v'}, ';', ':')
vim.keymap.set({'n', 'v'}, ':', ';')
vim.keymap.set({'n', 'v'}, '-', '^')
vim.keymap.set({'n', 'v'}, '=', '$')
vim.keymap.set({'n', 'v', 'i'}, '<C-f>', '<esc>')
vim.keymap.set({'n', 'v', 'i'}, '<C-h>', ';bp<cr>')
vim.keymap.set({'n', 'v', 'i'}, '<C-l>', ';bn<cr>')
-- display split
vim.keymap.set('n', 's', '<nop>')
vim.keymap.set('n', 'sj', '<C-w>j')
vim.keymap.set('n', 'sk', '<C-w>k')
vim.keymap.set('n', 'sl', '<C-w>l')
vim.keymap.set('n', 'sh', '<C-w>h')
vim.keymap.set('n', 'sJ', '<C-w>J')
vim.keymap.set('n', 'sK', '<C-w>K')
vim.keymap.set('n', 'sL', '<C-w>L')
vim.keymap.set('n', 'sH', '<C-w>H')
vim.keymap.set('n', 'ss', ':<C-u>sp<cr>')
vim.keymap.set('n', 'sv', ':<C-u>vs<cr>')

-- git
vim.keymap.set({'n', 'v', 'i'}, ',g', ':noh<cr>')
-- spell
vim.keymap.set('n', '<C-s>', ':setlocal spell!<cr>')
