-- set leader key to space
vim.g.mapleader = " "
vim.g.maploaclleader = " "

local map = vim.keymap.set

-- telescope 
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>",  { desc = "live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>",    { desc = "find bufers" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>",   { desc = "recent files" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>",  { desc = "help tags" })

