-- Modern keymaps for productivity and ergonomics
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Remap space as leader key (LazyVim already does this, but explicit is good)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Better escape sequences
keymap.set("i", "jk", "<ESC>", opts)
keymap.set("i", "kj", "<ESC>", opts)

-- Save with Ctrl+S (works in insert and normal mode)
keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Better navigation
-- Move to window using the <ctrl> hjkl keys
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize windows with arrow keys
keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Better line movement
-- Move lines up/down in visual mode
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Keep cursor centered when scrolling
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
keymap.set("n", "n", "nzzzv", { desc = "Next search result and center" })
keymap.set("n", "N", "Nzzzv", { desc = "Previous search result and center" })

-- Better line joining (keep cursor position)
keymap.set("n", "J", "mzJ`z", { desc = "Join lines without moving cursor" })

-- Better indenting in visual mode
keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Clear search highlighting
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Better paste behavior
-- Don't yank when pasting over selection
keymap.set("x", "p", [["_dP]], { desc = "Paste without yanking" })

-- Copy to system clipboard
keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to system clipboard" })
keymap.set("n", "<leader>Y", [["+Y]], { desc = "Copy line to system clipboard" })

-- Delete to void register (don't affect clipboard)
keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to void register" })

-- Quick actions
keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { desc = "Make file executable", silent = true })

-- Buffer management
keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Tab management
keymap.set("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
keymap.set("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
keymap.set("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
keymap.set("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
keymap.set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
keymap.set("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- Search and replace
keymap.set(
	"n",
	"<leader>sr",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Search and replace word under cursor" }
)

-- Quickfix navigation
keymap.set("n", "<leader>qo", "<cmd>copen<cr>", { desc = "Open quickfix list" })
keymap.set("n", "<leader>qc", "<cmd>cclose<cr>", { desc = "Close quickfix list" })
keymap.set("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix item" })
keymap.set("n", "[q", "<cmd>cprev<cr>", { desc = "Previous quickfix item" })

-- Location list navigation
keymap.set("n", "<leader>lo", "<cmd>lopen<cr>", { desc = "Open location list" })
keymap.set("n", "<leader>lc", "<cmd>lclose<cr>", { desc = "Close location list" })
keymap.set("n", "]l", "<cmd>lnext<cr>", { desc = "Next location item" })
keymap.set("n", "[l", "<cmd>lprev<cr>", { desc = "Previous location item" })

-- Diagnostic navigation (works with LSP)
keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic error messages" })
keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic quickfix list" })

-- Terminal mode escapes
keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
keymap.set("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
keymap.set("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- Modern text objects and motions
-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

-- Better word navigation
keymap.set("n", "W", "5w", { desc = "Jump 5 words forward" })
keymap.set("n", "B", "5b", { desc = "Jump 5 words backward" })

-- Quick semicolon/comma at end of line
keymap.set("i", "<C-;>", "<End>;", { desc = "Add semicolon at end of line" })
keymap.set("i", "<C-,>", "<End>,", { desc = "Add comma at end of line" })

-- Command line mode improvements
keymap.set("c", "<C-a>", "<Home>", { desc = "Go to beginning of line" })
keymap.set("c", "<C-e>", "<End>", { desc = "Go to end of line" })

-- File operations
keymap.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- Window splits
keymap.set("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true })
keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
keymap.set("n", "<leader>w-", "<C-W>s", { desc = "Split window below", remap = true })
keymap.set("n", "<leader>w|", "<C-W>v", { desc = "Split window right", remap = true })
keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true })
keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split window right", remap = true })

-- Lazy shortcuts
keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Mason shortcuts
keymap.set("n", "<leader>cm", "<cmd>Mason<cr>", { desc = "Mason" })

-- Better command history navigation
keymap.set("c", "<C-p>", "<Up>", { desc = "Previous command" })
keymap.set("c", "<C-n>", "<Down>", { desc = "Next command" })

-- Undo break points (create undo break points for better undo granularity)
keymap.set("i", ",", ",<c-g>u")
keymap.set("i", ".", ".<c-g>u")
keymap.set("i", ";", ";<c-g>u")

-- Source current lua file
keymap.set("n", "<leader><leader>x", "<cmd>source %<cr>", { desc = "Source current file" })
keymap.set("n", "<leader><leader>X", "<cmd>luafile %<cr>", { desc = "Luafile current file" })

