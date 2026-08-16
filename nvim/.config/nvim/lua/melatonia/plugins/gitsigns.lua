return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add          = { text = '┃' },
      change       = { text = '┃' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
    signs_staged = {
      add          = { text = '┃' },
      change       = { text = '┃' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
    signs_staged_enable = true,
    signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
    numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
      follow_files = true
    },
    auto_attach = true,
    attach_to_untracked = false,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
      delay = 1000,
      ignore_whitespace = false,
      virt_text_priority = 100,
      use_focus = true,
    },
    current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
    blame_formatter = nil, -- Use default
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000, -- Disable if file is longer than this (in lines)
    preview_config = {
      -- Options passed to nvim_open_win
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1
    },
    on_attach = function(bufnr)
      local gitsigns = require('gitsigns')

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal({']c', bang = true})
        else
          gitsigns.nav_hunk('next')
        end
      end, { desc = "next git hunk" })

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal({'[c', bang = true})
        else
          gitsigns.nav_hunk('prev')
        end
      end, { desc = "previous git hunk"})

      -- Actions
      map('n', '<leader>hs', gitsigns.stage_hunk, { desc = "stage hunk" })
      map('n', '<leader>hr', gitsigns.reset_hunk, { desc = "reset hunk" })

      map('v', '<leader>hs', function()
        gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, { desc = "stage selected hunk" })

      map('v', '<leader>hr', function()
        gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, { desc = "reset selected hunk" })

      map('n', '<leader>hS', gitsigns.stage_buffer, {desc = "stage buffer" })
      map('n', '<leader>hR', gitsigns.reset_buffer, {desc = "reset buffer" })
      map('n', '<leader>hp', gitsigns.preview_hunk, {desc = "preview hunk" })
      map('n', '<leader>hi', gitsigns.preview_hunk_inline, {desc = "preview hunk inline" })

      map('n', '<leader>hb', function()
        gitsigns.blame_line({ full = true } )
      end, { desc = "blame line (full)" })

      map('n', '<leader>hd', gitsigns.diffthis, { desc = "diff index" })

      map('n', '<leader>hD', function()
        gitsigns.diffthis('~')
      end, { desc = "diff last commit" })

      map('n', '<leader>hQ', function() gitsigns.setqflist('all') end, { desc = "all hunks to quickdiff" })
      map('n', '<leader>hq', gitsigns.setqflist, { desc = "buffer hunks to quickdiff" })

      -- Toggles
      map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = "toggle line blame" })
      map('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = "toggle word diff" })

      -- Text object
      map({'o', 'x'}, 'ih', gitsigns.select_hunk, { desc = "select git hunk" })
    end
  },
}
