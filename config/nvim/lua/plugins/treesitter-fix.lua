-- Fix for nvim-treesitter query_predicates location change
return {
  {
    "nvim-treesitter/nvim-treesitter",
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp early
      require("lazy.core.loader").add_to_rtp(plugin)
      -- Don't try to require query_predicates - it's now a plugin, not a module
      -- The file exists at plugin/query_predicates.lua and will be loaded automatically
    end,
  },
}
