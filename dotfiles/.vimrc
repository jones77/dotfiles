set nocompatible
filetype off
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
"
Plugin 'tpope/vim-obsession'
Plugin 'scrooloose/nerdtree'
"
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" standard Vim settings
syntax on
set autochdir
set autoindent
set expandtab
set hlsearch
set ignorecase
set ruler               " show cursor position in status line
set shiftwidth=4
set showcmd             " show partial command in status line
set showmatch           " show matching bracket
set smarttab
set softtabstop=4       " no hard tabs
set textwidth=80
set whichwrap=b,s,,>,h,l
set wrap                " wrap lines
set scrolloff=4
set nu

" both?
set title titleold=%%F%=%l/%L-%P titlelen=70

" unix specific
set t_vb= "who needs a visual bell anyway?
set t_te= "stops vim clearing the screen

" :T -> create tab, :H -> left, L -> right
command! -nargs=? T :tabnew 
map H :tabprev<return>
map L :tabnext<return>

" automatically load Session file
" - if it exists and no file arguments were specified
:if !empty(glob("Session.vim")) && argc() == 0
:   source Session.vim
:endif

map <space> 

colorscheme hybrid

