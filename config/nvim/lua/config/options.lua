-- Modern Neovim options for 2025
local opt = vim.opt

-- Editor behavior
opt.relativenumber = true -- Relative line numbers for easy jumping
opt.scrolloff = 8 -- Keep 8 lines visible when scrolling
opt.sidescrolloff = 8 -- Keep 8 columns visible when side scrolling
opt.wrap = false -- Don't wrap long lines
opt.linebreak = true -- Break lines at word boundaries when wrap is on
opt.breakindent = true -- Maintain indent when wrapping

-- Search and replace
opt.ignorecase = true -- Ignore case in search
opt.smartcase = true -- Override ignorecase if search contains uppercase
opt.inccommand = "split" -- Show live preview of substitute commands

-- Performance and UX
opt.updatetime = 250 -- Faster completion (default 4000ms)
opt.timeoutlen = 300 -- Faster key sequence timeout
opt.undofile = true -- Persistent undo across sessions
opt.swapfile = false -- Disable swap files (we have undo files)
opt.backup = false -- Don't create backup files

-- Visual improvements
opt.termguicolors = true -- Enable 24-bit RGB colors
opt.signcolumn = "yes" -- Always show sign column
opt.cursorline = true -- Highlight current line
opt.list = true -- Show invisible characters
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
-- Simplified fillchars (using ASCII characters)
opt.fillchars = {
  foldopen = "-",
  foldclose = "+",
  fold = " ",
  foldsep = " ",
  diff = "/",
  eob = " ",
}

-- Indentation (LazyVim handles most, but these are good defaults)
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 2 -- Size of an indent
opt.tabstop = 2 -- Number of spaces tabs count for
opt.smartindent = true -- Smart auto-indenting

-- Window behavior
opt.splitright = true -- Vertical splits to the right
opt.splitbelow = true -- Horizontal splits below
opt.winminwidth = 1 -- Minimum window width
opt.winminheight = 1 -- Minimum window height

-- Command line
opt.cmdheight = 0 -- Hide command line when not in use (Neovim 0.8+)
opt.pumheight = 10 -- Maximum number of items in popup menu

-- Fold settings
opt.foldmethod = "expr" -- Use expression for folding
opt.foldexpr = "nvim_treesitter#foldexpr()" -- Use treesitter for folding
opt.foldlevel = 99 -- Start with all folds open
opt.foldlevelstart = 99 -- Start with all folds open

-- Clipboard (handled by providers.lua but good to have as fallback)
if vim.fn.has("wsl") == 0 and vim.fn.has("mac") == 0 then
  opt.clipboard = "unnamedplus" -- Use system clipboard on Linux
end

-- File handling
opt.fileencoding = "utf-8" -- File encoding
opt.autowrite = true -- Auto write when switching buffers
opt.confirm = true -- Confirm before closing unsaved files

-- Mouse and selection
opt.mouse = "a" -- Enable mouse in all modes
opt.selection = "exclusive" -- Exclusive selection mode

-- Spelling (useful for markdown, comments)
opt.spelllang = { "en" }
opt.spelloptions:append("noplainbuffer") -- Don't spell check plain buffers

-- Session options
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- Format options
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"

-- Disable some built-in plugins we don't need
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1

-- Modern diagnostics
vim.diagnostic.config({
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})