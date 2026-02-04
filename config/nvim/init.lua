-- Minimal LazyVim Configuration
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup providers (fixed version)
local function setup_providers()
  -- Python provider (robust detection with mise)
  local function find_python_host()
    -- Try mise which (actual binary path)
    local path = vim.fn.system("mise which python 2>/dev/null"):gsub("%s+$", "")
    if path ~= "" and vim.fn.executable(path) == 1 then
      return path
    end
    -- Fallbacks
    path = vim.fn.system("command -v python3 2>/dev/null"):gsub("%s+$", "")
    if path ~= "" and vim.fn.executable(path) == 1 then
      return path
    end
    path = vim.fn.system("command -v python 2>/dev/null"):gsub("%s+$", "")
    if path ~= "" and vim.fn.executable(path) == 1 then
      return path
    end
    return nil
  end

  local host = find_python_host()
  if host then
    vim.g.python3_host_prog = host
    -- Check for pynvim and hint if missing (non-fatal)
    vim.fn.system({ host, "-c", "import pynvim" })
    if vim.v.shell_error ~= 0 then
      vim.schedule(function()
        vim.notify(
          "Neovim Python provider: 'pynvim' not found in " .. host .. "\n" ..
          "Install with: pip install --user pynvim\n" ..
          "If using mise: mise exec -- pip install -U pip pynvim",
          vim.log.levels.WARN
        )
      end)
    end
  end

  -- Disable unused providers for performance
  vim.g.loaded_ruby_provider = 0
  vim.g.loaded_perl_provider = 0
  vim.g.loaded_node_provider = 0
end

setup_providers()

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- Import LazyVim and install your plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    
    -- Essential extras only
    { import = "lazyvim.plugins.extras.lang.python" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    
    -- Import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
  },
  install = { colorscheme = { "catppuccin", "habamax" } },
  checker = { enabled = false }, -- disabled due to mason-lspconfig early loading errors
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
