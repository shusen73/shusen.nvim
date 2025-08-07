return {
  -- 🌐 Main LSP Plugin
  'neovim/nvim-lspconfig',
  event = 'VeryLazy', -- Corrected typo: `evnet` → `event`

  dependencies = {
    -- 🧱 Base LSP Tool Installer
    { 'williamboman/mason.nvim', opts = {} },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- 📶 LSP Status UI (e.g., progress spinner)
    { 'j-hui/fidget.nvim', opts = {} },
  },

  config = function()
    -- 🧠 Setup keybindings when an LSP server attaches to a buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- 🧭 Navigation
        map('gd', require('fzf-lua').lsp_definitions, '[G]oto [d]efinition')
        map('gr', require('fzf-lua').lsp_references, '[G]oto [r]eferences')

        map('gI', require('fzf-lua').lsp_implementations, '[G]oto [I]mplementation')
        map('gD', require('fzf-lua').lsp_declarations, '[G]oto [D]eclarations')

        map('gT', require('fzf-lua').lsp_typedefs, '[T]ype Definition')

        -- 🔍 Symbol Search
        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        map('<leader>ds', require('fzf-lua').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('fzf-lua').lsp_live_workspace_symbols, '[W]orkspace [S]ymbols')

        -- 🛠 Code Actions & Rename

        -- Rename the variable under your cursor.
        map('<leader>cr', vim.lsp.buf.rename, '[R]e[n]ame')
        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map('<leader>ca', require('fzf-lua').lsp_code_actions, '[C]ode [A]ction', { 'n', 'x' })

        -- 🧾 Signature Help in insert mode
        -- Opens a popup that displays documentation about the word under your cursor
        --  See `:help K` for why this keymap.
        -- map('K', vim.lsp.buf.hover, 'Hover Documentation')

        vim.keymap.set('i', '<c-s>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', { buffer = event.buf, desc = 'LSP: ' .. '[S]ignature Help' })

        -- ✨ Highlight symbol under cursor

        -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
        ---@param client vim.lsp.Client
        ---@param method vim.lsp.protocol.Method
        ---@param bufnr? integer some lsp support methods only in specific files
        ---@return boolean
        local function client_supports_method(client, method, bufnr)
          if vim.fn.has 'nvim-0.11' == 1 then
            return client:supports_method(method, bufnr)
          else
            return client.supports_method(method, { bufnr = bufnr })
          end
        end

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        -- The following code creates a keymap to toggle inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        -- if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
        --   map('<leader>th', function()
        --     vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        --   end, '[T]oggle Inlay [H]ints')
        -- end
      end,
    })

    -- ⚙️ Diagnostic UI Config

    -- See :help vim.diagnostic.Opts
    vim.diagnostic.config {
      severity_sort = true,
      float = { border = 'rounded', source = 'if_many' },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.INFO] = '󰋽 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
      } or {},
      virtual_text = {
        source = 'if_many',
        spacing = 2,
        format = function(diagnostic)
          local diagnostic_message = {
            [vim.diagnostic.severity.ERROR] = diagnostic.message,
            [vim.diagnostic.severity.WARN] = diagnostic.message,
            [vim.diagnostic.severity.INFO] = diagnostic.message,
            [vim.diagnostic.severity.HINT] = diagnostic.message,
          }
          return diagnostic_message[diagnostic.severity]
        end,
      },
      -- virtual_lines = true,
    }

    -- 🧠 Set up LSP capabilities (e.g., for cmp integration)

    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP specification.
    --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
    local original_capabilities = vim.lsp.protocol.make_client_capabilities()
    local capabilities = require('blink.cmp').get_lsp_capabilities(original_capabilities)
    -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- Enable the following language servers
    --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
    --
    --  Add any additional override configuration in the following tables. Available keys are:
    --  - cmd (table): Override the default command used to start the server
    --  - filetypes (table): Override the default list of associated filetypes for the server
    --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
    --  - settings (table): Override the default settings passed when initializing the server.
    --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/

    -- 📁 Add custom filetypes

    -- Registe templ file extension
    vim.filetype.add { extension = { templ = 'templ' } }

    -- 🚀 Define LSP servers and per-server overrides

    local servers = {
      -- clangd = {},
      ts_ls = {},
      elixirls = {},
      gopls = {},
      templ = {
        filetypes = { 'templ' },
      },
      prettierd = {
        filetypes = { 'html' },
      }, -- used to format javascript
      -- rust_analyzer = {},
      -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
      --
      -- Some languages (like typescript) have entire language plugins that can be useful:
      --    https://github.com/pmizio/typescript-tools.nvim
      --
      -- But for many setups, the LSP (`ts_ls`) will work just fine
      -- ts_ls = {},
      --

      lua_ls = {
        -- cmd = { ... },
        -- filetypes = { ... },
        -- capabilities = {},
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
    }

    -- 📦 Tools to install automatically via Mason

    -- Ensure the servers and tools above are installed
    --
    -- To check the current status of installed tools and/or manually install
    -- other tools, you can run
    --    :Mason
    --
    -- You can press `g?` for help in this menu.
    --
    -- `mason` had to be setup earlier: to configure its options see the
    -- `dependencies` table for `nvim-lspconfig` above.
    --
    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua', -- Used to format Lua code
      'prettierd', -- used to format javascript
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
      automatic_installation = false,
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          -- This handles overriding only values explicitly passed
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (for example, turning off formatting for ts_ls)
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }
  end,
}
