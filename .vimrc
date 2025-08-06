set nocompatible

set tabstop=4
set expandtab
set softtabstop=4
set shiftwidth=4
set shiftround

set ignorecase
set exrc

" Visual " {{{
    set number
    set numberwidth=4
    set laststatus=2
    set hlsearch
    set nowrap
"   set listchars=eol:¬,tab:>·,trail:␣,extends:>,precedes:<
"   set list
" " }}}

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
let g:ackprg = 'ag --nogroup --nocolor --column'

call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'file:///home/gmarik/path/to/plugin'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'

" Themes
Plugin 'sjl/badwolf'
Plugin 'morhetz/gruvbox'


" All of your Plugins must be added before the following line
call vundle#end()            " required

filetype plugin indent on    " required
color badwolf
syntax on

" Keyboard " {{{
    map <tab> :NERDTreeToggle<CR>
    map <C-P> :Files<CR>
    map <CS-F> :Ag<CR>
    map <C-K> :Tags<CR>
    map <F12> :make<CR>
    map! <F12> <ESC>:make<CR>i

    set pastetoggle=<F9>
" " }}}
