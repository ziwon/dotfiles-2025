-- Neovim 0.10+ is required by the bootstrap scripts, so Snacks explorer can stay enabled.
return {
	{
		"folke/snacks.nvim",
		opts = {
			explorer = {
				enabled = true,
			},
		},
	},
}
