require('material').setup({
	contrast = {
		sidebars = false,
		floating_windows = false,
		line_numbers = false,
		sign_column = false,
		cursor_line = false,
		non_current_windows = false,
	},

	high_visibility = {
		lighter = false,
		darker = false
	},

	disable = {
		colored_cursor = false,
		borders = false,
		background = true,
		term_colors = false,
		eob_lines = false
	},

	lualine_style = "default",

	async_loading = true,

	custom_highlights = {}
})

vim.g.material_style = "darker"

vim.cmd[[colorscheme material]]
