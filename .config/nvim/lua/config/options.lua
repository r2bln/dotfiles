local opt = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = " "

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.shiftround = true
opt.expandtab = true

opt.ignorecase = true
opt.smartcase = true
opt.exrc = true
opt.secure = true

opt.number = true
opt.numberwidth = 4
opt.relativenumber = true
opt.laststatus = 3
opt.hlsearch = true
opt.incsearch = true
opt.wrap = false
opt.signcolumn = "yes"
opt.cursorline = true
opt.termguicolors = true
opt.scrolloff = 4
opt.splitright = true
opt.splitbelow = true

opt.undofile = true
opt.swapfile = false

opt.updatetime = 250
opt.timeoutlen = 400

opt.listchars = { eol = "¬", tab = ">·", trail = "␣", extends = ">", precedes = "<" }
