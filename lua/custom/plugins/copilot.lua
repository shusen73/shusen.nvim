return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({
      panel = {
      },
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = "<C-f>"
        }
      },
      filetypes = {
      }
    })

    -- hide copilot suggestions when cmp menu is open
    -- to prevent odd behavior/garbled up suggestions
    local cmp = require 'cmp'
    local copilot = require 'copilot'
    cmp.event:on("menu_opened", function()
      ---@diagnostic disable-next-line: inject-field
      vim.b.copilot_suggestion_hidden = true
    end)
    cmp.event:on("menu_closed", function()
      ---@diagnostic disable-next-line: inject-field
      vim.b.copilot_suggestion_hidden = false
    end)
  end,
}
