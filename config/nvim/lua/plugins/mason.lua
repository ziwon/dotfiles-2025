-- Mason configuration for LazyVim
return {
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				-- Python
				"python-lsp-server",
				"black",
				"isort",
				"flake8",
				"mypy",
				"debugpy",
				-- JavaScript/TypeScript
				"typescript-language-server",
				"prettier",
				"eslint-lsp",
				-- Web
				"html-lsp",
				"css-lsp",
				"json-lsp",
				-- DevOps
				"yaml-language-server",
				"dockerfile-language-server",
				"terraform-ls",
				"bash-language-server",
			},
		},
	},
}
