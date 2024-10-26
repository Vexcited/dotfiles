local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  
  vim.keymap.set(mode, lhs, rhs, options)
end

map('n', '<space>e', vim.diagnostic.open_float, opts)
map('n', '[e', vim.diagnostic.goto_prev, opts)
map('n', ']e', vim.diagnostic.goto_next, opts)

map('n', '<A-Down>', ':m .+1<CR>==')
map('n', '<A-Up>', ':m .-2<CR>==')
map('i', '<A-Down>', '<Esc>:m .+1<CR>==gi')
map('i', '<A-Up>', '<Esc>:m .-2<CR>==gi')
map('v', '<A-Down>', ':m \'>+1<CR>gv=gv')
map('v', '<A-Up>', ':m \'<-2<CR>gv=gv')

