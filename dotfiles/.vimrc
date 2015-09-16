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

" both?
set title titleold=%%F%=%l/%L-%P titlelen=70

" unix specific
set t_vb= "who needs a visual bell anyway?
set t_te= "stops vim clearing the screen

" windows specific
set guifont=Dina:h8

" Tabs => :T => new tab, H => left, L => right
command! -nargs=? T :tabnew 
map H :tabprev
map L :tabnext

map <space> 

colors elflord

