-- set leader key to space
vim.g.mapleader = " "
vim.g.maploaclleader = " "

local map = vim.keymap.set

-- file
map("n", "<leader>w", "<cmd>w<cr>", { desc = "save file"} )
map("n", "<leader>q", "<cmd>q<cr>", { desc = "quit"} )

-- telescope 
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>",  { desc = "live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>",    { desc = "find bufers" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>",   { desc = "recent files" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>",  { desc = "help tags" })

-- window navigation
map("n", "<C-h>", "<C-w>h", { desc = "move to left split" })
map("n", "<C-j>", "<C-w>j", { desc = "move to lower split" })
map("n", "<C-k>", "<C-w>k", { desc = "move to upper split" })
map("n", "<C-l>", "<C-w>l", { desc = "move to right split" })
