vim.g.mapleader = ' ' -- <Space> Vim equivalent

vim.call('plug#begin')
local Plug = vim.fn['plug#']
Plug('tpope/vim-repeat')          -- Extend the Vim '.' operator
Plug('tpope/vim-surround')        -- Change (){}<>'' in a snap
Plug('godlygeek/tabular')         -- Easy automatic tabulations
Plug('tpope/vim-fugitive')        -- Probably best Git wrapper
Plug('mbbill/undotree')           -- Why only have linear undo tree?
Plug('junegunn/fzf')              -- Fuzzy finding, ripgrep
Plug('junegunn/fzf.vim')          -- Fuzzy finding, ripgrep
Plug('itchyny/lightline.vim')     -- A lightweight tab line
Plug('lifepillar/vim-solarized8') -- 'solarized8' colorscheme
Plug('whatyouhide/vim-gotham')    -- 'gotham' colorscheme
Plug('lewis6991/gitsigns.nvim')   -- Git signs
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' }) -- Treesitter
vim.call('plug#end')

-- General settings
vim.opt.autowrite = true                 -- Saves automatically when using :make / :next
vim.opt.autoread = true                  -- Reloads file when changed externally
vim.opt.backup = false                   -- No need for .bkp files with version control
vim.opt.writebackup = false              -- Disable backup before overwriting
vim.opt.swapfile = false                 -- Don't create swap files
vim.opt.sessionoptions:remove('options') -- Don't store options in sessions
vim.opt.undofile = true                  -- Persistent undo
vim.opt.history = 1024                   -- Number of stored commands
vim.opt.belloff = 'all'                  -- Disable audio bell

-- Netrw (file explorer) settings
vim.g.netrw_list_hide = '.*\\.swp$,\\.DS_Store,.*/tmp/.*,.*\\.so,.*\\.swp,.*\\.zip,^\\.git\\/$,^\\.\\.\\=/\\=$'
vim.g.netrw_keepj = ''

-- Formatting
vim.opt.expandtab = true               -- Expand tabs to spaces
vim.opt.shiftwidth = 4                 -- Indent size
vim.opt.shiftround = true              -- Round indent to nearest shiftwidth
vim.opt.tabstop = 4                    -- Tab size
vim.opt.softtabstop = 4                -- Spaces per tab in insert mode
vim.opt.formatoptions:append('j')      -- Delete comment when joining lines
vim.opt.autoindent = true              -- Copy previous indentation
vim.opt.smartindent = true             -- Smart indenting
vim.opt.backspace = 'indent,eol,start' -- Backspace behavior
vim.opt.lazyredraw = true              -- Better macro performance
vim.opt.ttimeout = true                -- Enable key code timeout
vim.opt.ttimeoutlen = 100              -- Key code timeout length

-- Searching
vim.opt.ignorecase = true      -- Case insensitive search
vim.opt.smartcase = true       -- Case sensitive when uppercase present
vim.opt.incsearch = true       -- Incremental search
vim.opt.hlsearch = true        -- Highlight search matches
vim.opt.magic = true           -- Enable regex

-- Interface settings
vim.opt.fileformats = 'unix,dos,mac'  -- Prioritize unix as the standard file type
vim.opt.encoding = 'utf-8'            -- Support for more characters
vim.opt.guicursor = ''                -- Apply same cursor behavior across diff. modes
vim.opt.winborder = 'rounded'
vim.opt.completeopt:append('menuone,noselect')
vim.opt.scrolloff = 8                 -- Scroll offset from top/bottom
vim.opt.foldmethod = 'indent'         -- Fold based on indentation
vim.opt.foldopen:append('jump')       -- Open folds when jumping to location
vim.opt.foldenable = false            -- Disable folding by default
vim.opt.signcolumn = 'yes'            -- Show sign column automatically
vim.opt.wrap = false                  -- Disable line wrapping
vim.opt.wildmenu = true               -- Command-line completion menu
vim.opt.cursorline = true             -- Highlight current line
vim.opt.shortmess = 'at'              -- Shorten some messages
vim.opt.showtabline = 2               -- Always show tab line
vim.opt.display = 'lastline'          -- Show as much as possible of last line
vim.opt.matchtime = 1                 -- How long to show matching brackets (in tenths of a second)
vim.opt.number = true                 -- Show line numbers
vim.opt.relativenumber = true         -- Show relative line numbers
vim.opt.ttyfast = true                -- Faster terminal connection
vim.opt.ruler = true                  -- Show cursor position
vim.opt.hidden = true                 -- Hide buffers instead of closing them
vim.opt.laststatus = 2                -- Always show status line
vim.opt.showmode = false              -- Disable mode display (handled by statusline)
vim.opt.termguicolors = true          -- Enable true color support
vim.opt.list = true                   -- Enables the characters to be displayed.
vim.opt.listchars = {
    tab      = '›\\',
    trail    = '•',
    extends  = '>',
    precedes = '<',
    nbsp     = '_'
}
vim.opt.background = 'dark'
vim.cmd.colorscheme('gotham')

-- FZF
-- Search is shown at the bottom
vim.g.fzf_layout = { down = '50%' }
-- Hide statusline when searching
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'fzf',
    callback = function()
        vim.opt.laststatus = 0
        vim.opt.showmode = false
        vim.opt.ruler = false
        vim.api.nvim_create_autocmd('BufLeave', {
            callback = function()
                vim.opt.laststatus = 2
                vim.opt.showmode = false
                vim.opt.ruler = true
            end
        })
    end
})

-- Treesitter
require('nvim-treesitter.configs').setup {
    ensure_installed = { 'lua', 'vim', 'vimdoc', 'markdown', 'javascript', 'typescript', 'rust', 'html', 'css', 'sql' },
    highlight = {
        enable = true,
        -- Disable treesitter highlight for large files
        disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,
    },
}

-- Lightline
vim.g.lightline = {
    colorscheme = 'gotham',
    active = {
        left = { { 'mode' }, { 'fugitive' }, { 'filename' } },
        right = { { 'lineinfo' } }
    },
    inactive = {
        left = { { 'mode' }, { 'fugitive' }, { 'filename' } },
        right = { { 'lineinfo' } }
    },
    component_function = {
        fugitive = 'FugitiveHead',
        readonly = 'LightLineReadonly'
    }
}

-- Git signs
require('gitsigns').setup()

-- LSP
vim.diagnostic.config({
    virtual_text  = true,
    virtual_line  = true,
    signs         = true,
    severity_sort = true,
})
-- Default LSP root marker
vim.lsp.config('*', {
    root_markers = { '.git' },
})
-- Default LSP capabilities
vim.lsp.config('*', {
    capabilities = {
        textDocument = {
            semanticTokens = {
                multilineTokenSupport = true,
            }
        }
    }
})
vim.lsp.config['rust-analyzer'] = {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    settings = {
        ['rust-analyzer'] = {
            procMacro = {
                enable = true
            },
            inlayHints = {
                maxLength = 10,
                parameterHints = {
                    enable = false
                }
            },
            -- cargo = {
                -- target = 'wasm32-unknown-unknown',
            -- }
        }
    }
}
vim.lsp.config['tsserver'] = {
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = { 'typescript', 'javascript' },
    root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json' },
    settings = {
        typescript = {
            inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = 'all', -- 'none' | 'literals' | 'all'
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = true,
            },
            completions = {
                completeFunctionCalls = true,
            },
            format = {
                indentSize = vim.bo.shiftwidth,
                convertTabsToSpaces = vim.bo.expandtab,
                tabSize = vim.bo.tabstop,
            },
        },
        javascript = {
            inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = 'all', -- 'none' | 'literals' | 'all'
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = true,
            },
            completions = {
                completeFunctionCalls = true,
            },
            format = {
                indentSize = vim.bo.shiftwidth,
                convertTabsToSpaces = vim.bo.expandtab,
                tabSize = vim.bo.tabstop,
            },
        },
        init_options = {
            hostInfo = 'neovim',
            preferences = {
                importModuleSpecifierPreference = 'shortest',
                allowTextChangesInNewFiles = true,
            },
        },
    }
}
vim.lsp.enable({ 'rust-analyzer', 'tsserver' })

-- Key mappings
-- Remove search highlight while keeping normal <C-L> functionality
vim.keymap.set('n', '<C-L>', '<cmd>silent! nohlsearch<CR><C-L>', { noremap = true, silent = true })
-- Quick save
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', { noremap = true })
-- Make Y behave like C and D (yank to end of line)
vim.keymap.set('n', 'Y', 'y$', { noremap = true })
-- FZF shortcuts
vim.keymap.set('n', '<leader>f', ':Files<CR>', { noremap = true })
vim.keymap.set('n', '<leader>g', ':Rg<CR>', { noremap = true })
vim.keymap.set('n', '<leader>b', ':Buffers<CR>', { noremap = true })
-- Tabulate shortcut
vim.keymap.set({'n', 'v'}, '<leader>t', ':Tab /', { noremap = true })
-- Undotree toggle
vim.keymap.set('n', '<leader>u', ':UndotreeToggle<CR>', { noremap = true })

-- LSP runtime settings
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local opts = { buffer = args.buf, remap = false }
      if client:supports_method('textDocument/completion') then
          vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = false })
          ---[[Code required to add documentation popup for an item
          local _, cancel_prev = nil, function() end
          vim.api.nvim_create_autocmd('CompleteChanged', {
              buffer = args.buf,
              callback = function()
                  cancel_prev()
                  local info = vim.fn.complete_info({ 'selected' })
                  local completionItem = vim.tbl_get(vim.v.completed_item, 'user_data', 'nvim', 'lsp', 'completion_item')
                  if nil == completionItem then
                      return
                  end
                  _, cancel_prev = vim.lsp.buf_request(args.buf,
                  vim.lsp.protocol.Methods.completionItem_resolve,
                  completionItem,
                  function(err, item, ctx)
                      if not item then
                          return
                      end
                      local docs = (item.documentation or {}).value
                      local win = vim.api.nvim__complete_set(info['selected'], { info = docs })
                      if win.winid and vim.api.nvim_win_is_valid(win.winid) then
                          vim.treesitter.start(win.bufnr, 'markdown')
                          vim.wo[win.winid].conceallevel = 3
                      end
                  end)
              end
          })
          ---]]
      end
      if vim.lsp.inlay_hint then
          vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
          vim.keymap.set('n', '<leader>L', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(), { bufnr = args.buf }) end, opts)
      end
      if not client:supports_method('textDocument/willSaveWaitUntil')
          and client:supports_method('textDocument/formatting') then
          vim.api.nvim_create_autocmd('BufWritePre', {
              group = vim.api.nvim_create_augroup('lsp', { clear = false }),
              buffer = args.buf,
              callback = function()
                  vim.lsp.buf.format({
                      bufnr = args.buf,
                      id = client.id,
                      timeout_ms = 1000,
                      async = false,
                      filter = function(client) return client.name == 'rust-analyzer' or client.name == 'tsserver' end
                  })
              end,
          })
      end
      vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
      vim.keymap.set('n', '<leader>d', function() vim.diagnostic.open_float() end, opts)
      vim.keymap.set('n', '[d', function() vim.diagnostic.goto_next() end, opts)
      vim.keymap.set('n', ']d', function() vim.diagnostic.goto_prev() end, opts)
  end,
})
