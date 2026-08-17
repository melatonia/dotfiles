-- lua/plugins/dashboard.lua

return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("dashboard").setup({
			theme = "doom",
			config = {
				header = {
					"  ,-.       _,---._ __  / \\",
					" /  )    .-'       `./ /   \\",
					" (  (   ,'            `/    /|",
					"  \\  `-\"             \\'\\   / |",
					"   `.              ,  \\ \\ /  |",
					"    /`.          ,'-`----Y   |",
					"   (            ;        |   '",
					"  |  ,-.    ,-'         |  /",
					" |  | (   |      melo. | /",
					" )  |  \\  `.___________|/",
					"`--'   `--'            ",
				},
				center = {
					{
						icon = " ",
						desc = "find file",
						key = "f",
						action = "Telescope find_files",
					},
					{
						icon = "󱎸 ",
						desc = "find text",
						key = "g",
						action = "Telescope live_grep",
					},
					{
						icon = " ",
						desc = "recent files",
						key = "r",
						action = "Telescope oldfiles",
					},
					{
						icon = "󰒲 ",
						desc = "lazy",
						key = "l",
						action = "Lazy",
					},
					{
						icon = " ",
						desc = "quit",
						key = "q",
						action = "qa",
					},
				},
				footer = function()
					local version = vim.version()
					return {
						"",
						string.format(" neovim v%d.%d.%d", version.major, version.minor, version.patch),
					}
				end,
			},
		})
	end,
}
