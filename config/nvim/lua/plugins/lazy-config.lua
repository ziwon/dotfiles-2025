-- Lazy.nvim configuration overrides
return {
  {
    "folke/lazy.nvim",
    opts = {
      rocks = {
        enabled = false,  -- Disable luarocks support
      },
    },
  },
}
