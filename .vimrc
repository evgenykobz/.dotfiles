let mapleader   = "\<Space>"
let g:mapleader = "\<Space>"

" Defaults
set nocompatible
filetype plugin indent on
syntax on

" Plugins with 'junegunn/vim-plug'
call plug#begin()
Plug 'tpope/vim-repeat'          " Extend the Vim '.' operator.
Plug 'tpope/vim-commentary'      " Better commenting with 'gc'.
Plug 'tpope/vim-surround'        " Change (){}<>'' in a snap.
Plug 'godlygeek/tabular'         " Easy automatic tabulations.
Plug 'tpope/vim-fugitive'        " Probably best Git wrapper.
Plug 'mbbill/undotree'           " Why only have linear undo tree?
Plug 'junegunn/fzf'              " Fuzzy finding, ripgrep.
Plug 'junegunn/fzf.vim'          " -=-=-
Plug 'itchyny/lightline.vim'     " A lightweight tab line.
Plug 'luxed/ayu-vim'             " 'ayu' colorscheme.
Plug 'lifepillar/vim-solarized8' " 'solarized8' colorscheme.
Plug 'airblade/vim-gitgutter'    " Git diff markers.
call plug#end()

" General
set viminfo+=n~/.vim/.viminfo  " Prevent collission with NeoVim.
set autowrite                  " Saves automatically when using :make / :next.
set autoread                   " Reloads file when it has been changed externally.
set nobackup                   " No need for .bkp files when version control exist.
set nowritebackup              " If Vim crashes often then turn backups on again, look at docs for more information.
set noswapfile                 " Don't create swap files, nowadays we should have enough memory to store a text file.
set sessionoptions-=options    " Don't store options (global variables etc...) when making a session.
set undodir=~/.vim/.vim_undoes " Files with dots are supported in Windows too, no need for distinction.
set undofile                   " Enables persistent undo, allowing to undo changes accross different sessions.
set history=1024               " Defines the number of stored commands Vim can remember.
set belloff=all                " Disables audio bell that constantly goes off in Windows version of gvim at least...

" Hides irrelevant options from the built-in file explorer.
let g:netrw_list_hide='.*\.swp$,.DS_Store,*/tmp/*,*.so,*.swp,*.zip,^\.git\/$,^\.\.\=/\=$'
let g:netrw_keepj=''

" Formatting
set expandtab        " Expand tab characters to space characters.
set shiftwidth=4     " One tab is now 4 spaces.
set shiftround       " Always round up to the nearest tab.
set tabstop=4        " This one is also needed to achieve the desired effect.
set softtabstop=4    " Enables easy removal of an indentation level.
set formatoptions+=j " Delete comment character when joining commented lines.
set autoindent       " Auto-magically copies the previous indentations.
set smartindent      " Applies smart indenting
set backspace=2      " Used for making backspace work like in most other editors (e.g. removing a single indent).
set lazyredraw       " Good performance boost when executing macros, redraw the screen only on certain commands.
set ttimeout         " Enables key codes timeout
set ttimeoutlen=1000 " Times out on key codes after a second

" Completion
set complete-=i          " Don't search included files (it's slow).
set completeopt+=longest " Only autocomplete widest match.

" Searching
set ignorecase                       " Search is not case sensitive, which is usually what we want.
set smartcase                        " Will override some ignorecase properties, when using caps it will do a special search.
set incsearch                        " Enables the user to step through each search 'hit', usually what is desired here.
set hlsearch                         " Will stop highlighting current search 'hits' when another search is performed.
set magic                            " Enables regular expressions. They are a bit like magic (not really though, DFA).
" Fzf settings
let g:fzf_layout = { 'down': '50%' } " Search is shown at the bottom.
" Hides statusline when searching
autocmd FileType fzf set laststatus=0 noshowmode noruler | autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler

" Interface
set fileformats=unix,dos,mac " Prioritize unix as the standard file type.
set encoding=utf-8           " Vim can now work with a whole bunch more characters (powerline too).
set scrolloff=8              " The screen will only scroll when the cursor is 8 characters from the top/bottom.
set foldmethod=indent        " Pressing zc will close a fold at the current indent while zo will open one.
set foldopen+=jump           " Additionally, open folds when there is a direct jump to the location.
set nofoldenable             " Disable folding by default, but allow it to be toggled back on with zi.
set signcolumn=auto
set nowrap
set wildmenu                 " Enable the 'autocomplete' menu when in command mode (':').
set cursorline               " For easier cursor spotting.
set shortmess=at             " Shorten some command mode messages, will keep you from having to hit ENTER all the time.
set showtabline=2            " Always show the tab lines, which makes the user interface a bit more consistent, 0 to hide the tabs
set display=lastline         " Displays as much as possible of the last line in a window.
set mat=1                    " How long the highlight will last.
set number                   " Show line numbers on left side.
set relativenumber           " Enables the user to easily see the relative distance between cursor and target line.
set ttyfast                  " Will send characters over a terminal connection faster. We do have fast connections after all.
set ruler                    " Always show current cursor position, which might be needed for the character column location.
set hidden                   " Abandon buffer when closed, which is usually what we want to do in this case.
set laststatus=2             " Always have a status line, this is required in order for Lightline to work correctly.
set noshowmode               " Disables standard -INSERT-, -NORMAL- in favor of Lightline
set t_Co=256                 " This will 'force' terminals to use 256 colors, enabling Lightline and the colorscheme to look correct.
set list                     " Enables the characters to be displayed.
set listchars=tab:›\ ,trail:•,extends:>,precedes:<,nbsp:_
" Colorsceme setting
set termguicolors
set background=dark
silent! colorscheme solarized8

" LightLine settings
function! GitStatus()
    if !get(g:, 'gitgutter_enabled', 0) || empty(FugitiveHead())
        return ''
    endif
    let [ l:added, l:modified, l:removed ] = GitGutterGetHunkSummary()
    return printf('+%d ~%d -%d', l:added, l:modified, l:removed)
endfunction
let g:lightline = {
\ 'colorscheme': 'solarized',
\ 'active': {
\  'left': [[ 'mode' ], [ 'fugitive' ], [ 'filename' ], [ 'git' ]],
\  'right': [[ 'lineinfo' ]]
\ },
\ 'inactive': {
\  'left': [[ 'mode' ], [ 'fugitive' ], [ 'filename' ], [ 'git' ]],
\  'right': [[ 'lineinfo' ]]
\ },
\ 'component_function': {
\  'fugitive': 'FugitiveHead',
\  'readonly': 'LightLineReadonly',
\  'git': 'GitStatus',
\ }
\ }

" Git gutter settings
let g:gitgutter_grep = 'rg' " Enables ripgrep instead of grep

" Removes latest search/replace highlight.
noremap  <silent> <C-L> :silent! nohlsearch<CR><C-L>
" Shortcut for quicker writes.
nnoremap <leader>w :w<CR>
" Applies behavior similar to 'C' and 'D' being simply y$.
nmap Y y$
" Shortcut for files finder.
nnoremap <leader>f :Files<CR>
" Shortcut for ripgrep.
nnoremap <leader>g :Rg<CR>
" Shortcut for buffers finder.
nnoremap <leader>b :Buffers<CR>
" Shortcut for Tabulate.
noremap  <leader>t :Tab /
" Shortcut for undotree.
noremap  <leader>u :UndotreeToggle<CR>
