-- Fix mason-lspconfig early loading issue
-- Ensure mason-lspconfig loads before nvim-lspconfig
-- Note: mason plugins were renamed from williamboman/* to mason-org/*
return {
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "mason-lspconfig.nvim" },
  },
}
