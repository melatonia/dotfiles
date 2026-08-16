return {
  'nvim-telescope/telescope.nvim', version = '*',
  dependenvies = {
    'nvim-lua/plenary.nvim',
    -- optional but recommended
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  }
}
