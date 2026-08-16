return {
  'sainnhe/gruvbox-material',
  lazy = false,
  priority = 1000, -- load before all other plugins so UI renders correctly
  config = function()
    vim.g.gruvbox_material_transparent_background = 1
    vim.g.gruvbox_material_material_background = 'medium'
    vim.g.gruvbox_material_enable_bold = 1
    vim.g.gruvbox_material_enable_italic = 1

    vim.cmd.colorscheme('gruvbox-material')
  end,
}
