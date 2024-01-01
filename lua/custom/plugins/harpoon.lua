return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim"
  },
  config = function()
    local harpoon = require("harpoon")
    -- REQUIRED
    harpoon:setup({})
    -- REQUIRED

    vim.keymap.set("n", "<C-a>", function() harpoon:list():append() end, { desc = 'Harpoon: append to list' })
    vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
      { desc = 'Harpoon: toggle menu' })

    vim.keymap.set("n", "<C-f>", function() harpoon:list():select(1) end, { desc = 'Harpoon: select 1' })
    vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end, { desc = 'Harpoon: select 2' })
    vim.keymap.set("n", "<C-g>", function() harpoon:list():select(3) end, { desc = 'Harpoon: select 3' })
    vim.keymap.set("n", "<C-h>", function() harpoon:list():select(4) end, { desc = 'Harpoon: select 4' })
  end,
}
