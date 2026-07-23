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

-- Подсветка активного тайла: текст в неактивных сплитах гасим, границу делаем ярче,
-- courserline оставляем только в текущем окне
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		vim.api.nvim_set_hl(0, "NormalNC", { fg = "#665c54" })
		vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#fe8019", bold = true })
	end,
})

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
	callback = function()
		vim.wo.cursorline = true
	end,
})
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
	callback = function()
		vim.wo.cursorline = false
	end,
})
