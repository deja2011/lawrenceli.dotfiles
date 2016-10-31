" begin Vundle setup
" be iMproved, required by Vundle
set nocompatible
" required by Vundle
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required by Vundle
Plugin 'VundleVim/Vundle.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'Valloric/MatchTagAlways'
Plugin 'matchit.zip'
Plugin 'Townk/vim-autoclose'
Plugin 'vim-scripts/closetag.vim'
Plugin 'vim-airline/vim-airline'

" NERD-tree setup
map  :NERDTreeToggle
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" end NERD-tree setup

"" " The following are examples of different formats supported.
"" " Keep Plugin commands between vundle#begin/end.
"" " plugin on GitHub repo
"" Plugin 'tpope/vim-fugitive'
"" " plugin from http://vim-scripts.org/vim/scripts.html
"" Plugin 'L9'
"" " Git plugin not hosted on GitHub
"" Plugin 'git://git.wincent.com/command-t.git'
"" " git repos on your local machine (i.e. when working on your own plugin)
"" Plugin 'file:///home/gmarik/path/to/plugin'
"" " The sparkup vim script is in a subdirectory of this repo called vim.
"" " Pass the path to set the runtimepath properly.
"" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
"" " Install L9 and avoid a Naming conflict if you've already installed a
"" " different version somewhere else.
"" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()

" required by Vundle
filetype plugin indent on
" To ignore plugin indent changes, instead use:
"filetype plugin on

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" end Vundle setup

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

colorscheme solarized


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
set shiftwidth=4
set softtabstop=4
set expandtab

" Enable swapfile and customize swap file directory to ~/.vimswp
set swapfile
set directory=~/.vimswp

" Allow intelligent auto-indenting for each filetype, and for plugins that are
" filetype specific
" filetype on
" filetype plugin on
" filetype indent on
filetype indent plugin on

" Allow intelligent folding
set foldenable
set foldmethod=syntax
set foldcolumn=0
setlocal foldlevel=1

" Map <C-L> (redraw screen) to also trun off search highlighting until the
" next search
nnoremap  :nohl
