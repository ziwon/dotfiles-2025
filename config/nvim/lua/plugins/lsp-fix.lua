-- Keep Mason loaded before mason-lspconfig and nvim-lspconfig.
return {
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "mason-org/mason-lspconfig.nvim" },
  },
}
