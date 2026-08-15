vim.g.mapleader = " "
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.wrap = false
vim.o.swapfile = false
vim.o.backup = false
vim.o.undofile = true
vim.o.hlsearch = false
vim.o.smartcase = true
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.termguicolors = true
vim.o.scrolloff = 8
vim.o.signcolumn = "yes"
vim.o.winborder = "rounded"
vim.opt.showtabline = 0
vim.o.confirm = true
vim.o.statusline = table.concat({
  "%f%m%r%h%w%=",
  "%{FugitiveHead() != '' ? 'git:' . FugitiveHead() . ' ' : ''}",
  "%y %l:%c %p%%"
})
vim.diagnostic.config({ virtual_text = true })
