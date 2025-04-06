return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  lazy = false,
  ---@module "ibl"
  ---@type ibl.config
  opts = {
    indent = {
      char = '┊',
    },
    scope = {
      show_start = false,
      show_end = false,
    },
  },
}
