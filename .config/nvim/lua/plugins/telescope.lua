return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	cmd = "Telescope",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		local telescope = require("telescope")
		telescope.setup({
			defaults = {
				file_ignore_patterns = { "%.git/" },
				-- nvim-treesitter (branch = "main") убрал ft_to_lang, на которую
				-- завязан treesitter-хайлайт в превьюере telescope 0.1.x — падает
				-- с "attempt to call field 'ft_to_lang' (a nil value)". Отключаем
				-- treesitter в preview, остаётся обычная :syntax-подсветка.
				preview = {
					treesitter = false,
				},
			},
		})
		telescope.load_extension("fzf")
	end,
}
