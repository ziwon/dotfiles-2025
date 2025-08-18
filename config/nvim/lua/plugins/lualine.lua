-- Lualine configuration with muted colors matching Oh My Posh theme
return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = function()
			-- Muted color palette matching Oh My Posh theme
			local colors = {
				bg = "#1e1e1e", -- Dark background
				fg = "#e8e8e8", -- Muted white foreground

				-- Segment colors matching Oh My Posh
				os_bg = "#8b5a3c", -- Muted brown (OS segment)
				user_bg = "#d0d0d0", -- Muted gray (User segment)
				path_bg = "#5a7a8a", -- Muted blue (Path segment)
				python_bg = "#4a5a6a", -- Muted slate (Python segment)
				git_bg = "#5a6b4a", -- Muted olive (Git segment)
				time_bg = "#8b5a3c", -- Muted brown (Time segment)

				-- Status colors
				normal = "#5a7a8a", -- Muted blue
				insert = "#5a6b4a", -- Muted green
				visual = "#8a5a7a", -- Muted magenta
				replace = "#8a5a5a", -- Muted red
				command = "#8a8a5a", -- Muted yellow
			}

			return {
				options = {
					theme = "catppuccin",
					globalstatus = true,
					disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
					-- Restore powerline separators like zsh prompt
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = {
						{
							"mode",
							fmt = function(str)
								return str:sub(1, 1) -- Show only first character of mode
							end,
						},
					},
					lualine_b = {
						{
							"branch",
							icon = "",
							color = { bg = colors.git_bg, fg = colors.fg },
						},
					},
					lualine_c = {
						{
							"filename",
							path = 1, -- Show relative path
							symbols = {
								modified = " ●",
								readonly = " ",
								unnamed = "[No Name]",
							},
							color = { bg = colors.path_bg, fg = colors.fg },
						},
						{
							"diff",
							symbols = {
								added = " ",
								modified = " ",
								removed = " ",
							},
							diff_color = {
								added = { fg = colors.git_bg },
								modified = { fg = colors.command },
								removed = { fg = colors.replace },
							},
						},
					},
					lualine_x = {
						{
							"diagnostics",
							symbols = {
								error = " ",
								warn = " ",
								info = " ",
								hint = " ",
							},
							diagnostics_color = {
								error = { fg = colors.replace },
								warn = { fg = colors.command },
								info = { fg = colors.normal },
								hint = { fg = "#5a8a8a" },
							},
						},
						{
							function()
								local msg = "No LSP"
								local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
								local clients = vim.lsp.get_active_clients()
								if next(clients) == nil then
									return msg
								end
								for _, client in ipairs(clients) do
									local filetypes = client.config.filetypes
									if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
										return client.name
									end
								end
								return msg
							end,
							icon = " ",
							color = { bg = colors.python_bg, fg = colors.fg },
						},
					},
					lualine_y = {
						{
							"filetype",
							icon_only = true,
							separator = "",
							padding = { left = 1, right = 0 },
						},
						{
							"progress",
							separator = " ",
							padding = { left = 1, right = 0 },
						},
						{
							"location",
							padding = { left = 0, right = 1 },
						},
					},
					lualine_z = {
						{
							function()
								return os.date("%H:%M")
							end,
							icon = "",
							color = { bg = colors.time_bg, fg = colors.fg, gui = "bold" },
						},
					},
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				extensions = { "neo-tree", "lazy" },
			}
		end,
	},
}
