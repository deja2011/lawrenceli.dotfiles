
set incsearch
set background=dark
color desert
" set guifont=Consolas\ 12

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

" Use visual bell instead of beeping when doing something wrong
set visualbell

" Show line number
set number

" Indentation settings for using 2 spaces instead of tabs.
set shiftwidth=4
set softtabstop=4
set expandtab

" Enable swapfile and customize swap file directory to ~/.vimswp
set swapfile
set directory=~/.vimswp

" Allow intelligent auto-indenting for each filetype, and for plugins that are
" filetype specific
" filetype off
"filetype plugin on
"filetype indent on
filetype indent plugin on

" Allow intelligent folding
set foldenable
set foldmethod=syntax
set foldcolumn=0
setlocal foldlevel=1

"" --------------------------------------------------------------------------------
"" Setup autocmd
"" --------------------------------------------------------------------------------
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType java set omnifunc=javacomplete#Complet


"" --------------------------------------------------------------------------------
"" Customized key mapping
"" --------------------------------------------------------------------------------
" " Mimic backspace in edit mode
" map!  cl
" " Mimic backspace in command mode
" map  hx
" [shift] + [h] to clear search cache and remove highlightening of matched
" patterns
map H :let @/=""
" Map <C-L> (redraw screen) to also trun off search highlighting until the
" next search
nnoremap  :nohl

syntax enable

" set rtp+=~/.vim/bundle/vundle/
" call vundle#rc()
" Bundle 'gmarik/vundle'
" Bundle 'altercation/vim-colors-solarized'

" colorscheme solarized
