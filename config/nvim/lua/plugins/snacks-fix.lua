-- Disable snacks explorer due to Neovim 0.9.5 API compatibility issues
-- The nvim_get_hl 'create' parameter requires Neovim 0.10+
return {
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {
        enabled = false, -- Disable until Neovim is upgraded to 0.10+
      },
    },
  },
}
