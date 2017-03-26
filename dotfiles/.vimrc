set nocompatible              " be iMproved, required
filetype off                  " required

"" VundleBegin
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
""

Plugin 'chrisbra/Recover.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'exu/pgsql.vim'
Plugin 'fatih/vim-go'
Plugin 'flazz/vim-colorschemes'
Plugin 'gregsexton/gitv'
Plugin 'heavenshell/vim-pydocstring'
Plugin 'hynek/vim-python-pep8-indent'
Plugin 'klen/python-mode'
Plugin 'mileszs/ack.vim'
Plugin 'mkitt/tabline.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-eunuch'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-obsession'
Plugin 'tpope/vim-capslock'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-scripts/burnttoast256'
Plugin 'guns/xterm-color-table.vim'

""
" All of your Plugins must be added before the following line
call vundle#end()         " required
filetype plugin indent on " required
" To ignore plugin indent changes, instead use:
"   filetype plugin on
" :PluginUpdate, :PluginList, :PluginInstall - `!` also update
" :PluginSearch foo - searches for foo, `!` refresh local cache
" :PluginClean - `!` auto-approve
"   see :h vundle for more details or wiki for FAQ
"" EndVundle

set background=dark
set term=putty-256color
set t_Co=256
colorscheme burnttoast256

let g:NERDTreeDirArrows=0
let g:NERDTreeShowHidden=1

let g:airline_powerline_fonts = 1
" Show capslock status in the statusline
let g:airline#extensions#capslock#enabled = 1


let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'

" https://github.com/scrooloose/syntastic#settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" Let pymode do the work
" let g:syntastic_mode_map = { 'passive_filetypes': ['python'] }

let g:pymode_doc = 0
let g:pymode_rope_complete_on_dot = 0

let g:sql_type_default = 'pgsql'

nmap <silent> <Leader>l <Plug>(pydocstring)

set encoding=utf-8

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

" unix specific
set t_vb= "who needs a visual bell anyway?
set t_te= "stops vim clearing the screen

" :T => new tab, H => left, L => right
command! -nargs=? T :tabnew 
map H :tabprev<return>
map L :tabnext<return>

map <space> 

augroup LoadOnce
    " Prevent progressively slower reloading time of .vimrc
    " http://stackoverflow.com/q/15353988
    autocmd!
    autocmd bufwritepost .vimrc source $MYVIMRC

    autocmd FileType c,cpp,python,ruby,java,sql
        \ autocmd BufWritePre <buffer> :%s/\s\+$//e
    autocmd BufNewFile,BufReadPost *.md set filetype=markdown
    autocmd Filetype gitcommit setlocal spell textwidth=72
augroup END

set relativenumber
set number
set ttyfast
set clipboard^=unnamed

set mouse=a
map <ScrollWheelUp> <C-U>
map <ScrollWheelDown> <C-D>
" Not sure why these need to be at the end to be respected.
hi CursorLineNr term=bold ctermfg=246 ctermbg=232
hi ColorColumn ctermbg=232
hi LineNr term=bold ctermfg=237 ctermbg=232
set colorcolumn=80
