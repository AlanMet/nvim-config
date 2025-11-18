vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "
vim.g.background = "light"

vim.opt.swapfile = false

-- Navigate vim panes better
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')
-- Open a horizontal terminal at the bottom AND enter insert mode
vim.keymap.set('n', '<leader>t', function()
  vim.cmd('belowright split') -- 1. Create the new split
  vim.cmd('terminal')         -- 2. Run terminal in the new window
  vim.cmd('startinsert')      -- 3. Start insert mode
end, { desc = "Open terminal below" })

vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')
vim.wo.number = true
