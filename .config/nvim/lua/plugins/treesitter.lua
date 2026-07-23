local ensure_installed = {
	"lua",
	"vim",
	"vimdoc",
	"query",
	"bash",
	"python",
	"javascript",
	"typescript",
	"tsx",
	"json",
	"yaml",
	"toml",
	"markdown",
	"markdown_inline",
	"c",
	"cpp",
	"rust",
	"go",
	"html",
	"css",
	"dockerfile",
	"regex",
	"diff",
	"gitcommit",
}

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").install(ensure_installed)

		vim.api.nvim_create_autocmd("FileType", {
			pattern = ensure_installed,
			callback = function()
				vim.treesitter.start()
				vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
