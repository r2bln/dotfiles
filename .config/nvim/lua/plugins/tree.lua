return {
	"nvim-tree/nvim-tree.lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = { "NvimTreeToggle", "NvimTreeFocus" },
	opts = {
		view = { width = 32 },
		renderer = { group_empty = true },
		filters = { dotfiles = false },
	},
}
