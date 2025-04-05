-- ===============================
-- 🚀 Indentation Settings
-- ===============================

vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.shiftwidth = 4 -- Indentation width
vim.opt.tabstop = 4 -- Tab character width
vim.opt.softtabstop = 4 -- Spaces per Tab key press
vim.opt.smarttab = true -- Smart handling of tabs with 'shiftwidth'
vim.opt.smartindent = true -- Auto-indent new lines based on syntax
vim.opt.autoindent = true -- Copy indentation from previous line
vim.opt.breakindent = true -- Maintain indentation for wrapped lines

-- ===============================
-- 🎨 UI Enhancements
-- ===============================

vim.opt.number = true -- Show absolute line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.cursorline = true -- Highlight the current line
vim.opt.signcolumn = 'yes' -- Always show sign column to prevent text shifting
vim.opt.showmode = false -- Hide mode display (use statusline instead)
vim.opt.list = true -- Show invisible characters
vim.opt.listchars = { -- Define symbols for invisible characters
  tab = '» ', -- Tab indicator
  trail = '·', -- Trailing spaces
  nbsp = '␣', -- Non-breaking spaces
}

-- ===============================
-- ⚡ Behavior Settings
-- ===============================

vim.opt.mouse = 'a' -- Enable mouse in all modes
vim.opt.undofile = true -- Persistent undo history
vim.opt.ignorecase = true -- Case-insensitive search
vim.opt.smartcase = true -- Case-sensitive if uppercase is used in search
vim.opt.splitright = true -- Open vertical splits to the right
vim.opt.splitbelow = true -- Open horizontal splits below
vim.opt.scrolloff = 10 -- Keep 10 lines visible above/below cursor

-- ===============================
-- ✨ Highlight on Yank (Copy)
-- ===============================

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
