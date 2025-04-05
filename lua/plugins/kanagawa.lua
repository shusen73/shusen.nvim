return {
  'rebelot/kanagawa.nvim',
  opts = {
    compile = true,
  },
  build = function()
    vim.cmd 'KanagawaCompile'
  end,
  config = function()
    vim.cmd [[colorscheme kanagawa]]
  end,
}
