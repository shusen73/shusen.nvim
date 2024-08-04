-- return {
--   'Exafunction/codeium.vim',
--   event = 'InsertEnter',
--   config = function()
--     -- Change '<C-g>' here to any keycode you like.
--     vim.keymap.set('i', '<C-g>', function()
--       return vim.fn['codeium#Accept']()
--     end, { expr = true, silent = true })
--   end,
-- }
return {
  -- 'sourcegraph/sg.nvim',
  -- dependencies = {
  --   'nvim-lua/plenary.nvim', --[[ "nvim-telescope/telescope.nvim ]]
  -- },
  -- config = function()
  --   require('sg').setup {}
  -- end,
}
