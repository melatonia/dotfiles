local opt = vim.opt

-- line numbers
opt.number = true -- show line numbers
opt.relativenumber = true -- relative line numbers

-- indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true -- convert tabs to spaces
opt.smartindent = true -- automatically add indentation

-- appearence
opt.cursorline = true -- highlight cursor line
opt.scrolloff = 8 -- keep 8 lines above / belove cursor

-- search 
opt.ignorecase = true
opt.smartcase = true -- case-sensitive only if you type uppercase

-- behaviour
opt.splitright = true
opt.splitbelow = true
opt.undofile = true -- persistent undo history across sessions
opt.clipboard = "unnamedplus" -- sync with system clipboard
opt.mouse = "a" -- mouse on all modes
opt.updatetime = 250 -- faster UI response (default 4000ms)
opt.timeoutlen = 300 -- faster whichkey popup (default 1000ms)
opt.confirm = true -- ask to save instead of erroring on :q

-- file type overrides
-- use 4 spaces on rust
vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.softtabstop = 4
    end,
})
