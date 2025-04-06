return {
  'rebelot/kanagawa.nvim',
  build = function()
    vim.cmd 'KanagawaCompile'
  end,
  config = function()
    require('kanagawa').setup {
      compile = true,
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = 'none',
            },
          },
        },
      },
      background = { -- map the value of 'background' option to a theme
        dark = 'wave', -- try "dragon" !
        light = 'lotus',
      },
      overrides = function(colors)
        local theme = colors.theme
        return {
          -- Transparent floating windows
          NormalFloat = { bg = 'none' },
          FloatBorder = { bg = 'none' }, -- Gray border lines
          FloatTitle = { bg = 'none' },

          -- Darker background option for specific cases
          NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

          -- Plugin-specific overrides (keep dark or transparent)
          LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
          MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

          -- Telescope (if used)
          TelescopeNormal = { bg = 'none' },
          TelescopeBorder = { bg = 'none' },

          -- blink.nvim tree (if used)
          BlinkTreeNormal = { bg = 'none' },
          BlinkTreeBorder = { bg = 'none' },

          -- blink.cmp (if used)
          BlinkCmpMenu = { bg = 'none' },
          BlinkCmpMenuBorder = { bg = 'none' },
          BlinkCmpDoc = { bg = 'none' },
          BlinkCmpDocBorder = { bg = 'none' },

          Pmenu = { bg = theme.ui.bg_p1, blend = vim.o.pumblend }, -- add `blend = vim.o.pumblend` to enable transparency
          PmenuSel = { fg = 'NONE', bg = theme.ui.bg_p2 },
          PmenuSbar = { bg = theme.ui.bg_m1 },
          PmenuThumb = { bg = theme.ui.bg_p2 },
        }
      end,
    }

    vim.cmd [[colorscheme kanagawa]]
  end,
}
