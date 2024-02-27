return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  config = function()
    require('neo-tree').setup {}
    -- map leader t to toggle filetree
    vim.keymap.set('n', '<leader>t', '<Cmd>Neotree toggle<CR>', { desc = 'Toggle filetree' })
  end,
}
