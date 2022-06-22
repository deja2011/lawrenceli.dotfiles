"" --------------------------------------------------------------------------------
"" Appearance settings
"" --------------------------------------------------------------------------------
syntax on
syntax enable
set background=dark
" Resolve Mac color issue
let g:solarized_termcolors = 256
let g:blue_termcolors = 256
let g:darkblue_termcolors = 256
let g:default_termcolors = 256
let g:delek_termcolors = 256
let g:desert_termcolors = 256
let g:elflord_termcolors = 256
let g:evening_termcolors = 256
let g:koehler_termcolors = 256
let g:morning_termcolors = 256
let g:murphy_termcolors = 256
let g:pablo_termcolors = 256

"" --------------------------------------------------------------------------------
"" Basic settings
"" --------------------------------------------------------------------------------
set incsearch

" Ward off unexpected things that resulted from vim distro. Reset options when
" re-sourcing .vimrc
set nocompatible

" Keep 50 lines of command line history
set history=50

" Better command-line completion
set wildmenu

" Show partial commands in the last line of the screen
set showcmd

" Highlight searches (use <C-L> to temporarily turn off highlighting)
set hlsearch

" Highlight current line
set cursorline

" Use caseinsensitive search, except when using capital letters
set ignorecase
set smartcase

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" Keep same indent as last line when entering newlines, if filetype-specific
" indenting is not enabled
set autoindent
set smartindent

" Show curser position all the time
set ruler

" Show status line all the time
set laststatus=2

" Start scrolling four lines before the horizontal window border
set scrolloff=4

" Show line number
set number

" Indentation settings for using 2 spaces instead of tabs.
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" Enable swapfile and customize swap file directory to ~/.vimswp
set swapfile
set directory=~/.vim/vimswp

" Allow intelligent auto-indenting for each filetype, and for plugins that are
" filetype specific
" filetype on
" filetype plugin on
" filetype indent on
filetype indent plugin on

" Allow intelligent folding
set nofoldenable
" set foldenable
set foldmethod=indent
set foldcolumn=0
setlocal foldlevel=1

" Force unix format
set fileformat=unix

" Force encoding
set encoding=utf-8

" Per file type format setup
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set expandtab |
    \ set autoindent |

au BufNewFile,BufRead *.html,*.css
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |

"" Flag out unnecessary whitespace
"highlight BadWhitespace ctermbg=red guibg=darkred
"au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" Enable python_highlight_all
let g:python_highlight_all=1

" Map <C-L> (redraw screen) to also trun off search highlighting until the
" next search
nnoremap  :nohl
