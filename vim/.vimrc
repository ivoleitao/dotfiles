"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Later
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
" let mapleader = ","
" let g:mapleader = ","

" Fast saving
" nmap <leader>w :w!<cr>

" :W sudo saves the file 
" (useful for handling the permission-denied error)
" command W w !sudo tee % > /dev/null

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc
set nocompatible

" Sets how many lines of history VIM has to remember
set history=700

" Attempt to determine the type of a file based on its name and possibly its
" contents.  Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editor
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Use spaces instead of tabs
set expandtab
" Be smart when using tabs ;)
set smarttab
" Indents will have a width of 4
set shiftwidth=4 
" The width of a TAB is set to 4.Vim will interpret it to be having a width of 4.
set tabstop=4
" Sets the number of columns for a TAB
set softtabstop=4 
" Linebreak on 500 characters
set lbr
set tw=500
" Auto indent
set ai 
" Smart indent
set si 
" Wrap lines
set wrap 

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" NERDtree
Plugin 'scrooloose/nerdtree'

" Fugitive
Plugin 'tpope/vim-fugitive'

" vim-airline 
Plugin 'bling/vim-airline' 

" syntastic
Plugin 'scrooloose/syntastic'

" ctrlp
Plugin 'kien/ctrlp.vim'

" ack
Plugin 'mileszs/ack.vim'

" surround
Plugin 'tpope/vim-surround'

" tagbar
Plugin 'majutsushi/tagbar'

" Solarized
Plugin 'altercation/vim-colors-solarized'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required


" Enable syntax highlighting
set t_Co=256
syntax on
set background=dark

let g:solarized_termtrans = 1
colorscheme solarized

"------------------------------------------------------------
"" Must have options
"
"" These are highly recommended options.
set cursorline

" One of the most important options to activate. Allows you to switch from an
" unsaved buffer without saving it first. Also allows you to keep an undo
" history for multiple files. Vim will complain if you try to quit without
" saving, and swap files will keep you safe if your computer crashes.
set hidden

" Better command-line completion
set wildmenu

" Show partial commands in the last line of the screen
set showcmd

" Highlight searches (use <C-L> to temporarily turn off highlighting; see the
" mapping of <C-L> below)
set hlsearch
 
" Modelines have historically been a source of security vulnerabilities.  As
" such, it may be a good idea to disable them and use the securemodelines
set nomodeline

" Always display the status line, even if only one window is displayed
set laststatus=2

" Use visual bell instead of beeping when doing something wrong
set visualbell

" Display line numbers on the left
set number

set pastetoggle=<F10>

"------------------------------------------------------------
" Mappings {{{1
"
" Useful mappings


" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L>

" NERDtree configuration
map <C-n> :NERDTreeToggle %<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let NERDTreeShowHidden=1

" Airline configuration
let g:airline_powerline_fonts = 1

" CtrlP configuration
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_user_command = 'find %s -type f'
let g:ctrlp_use_caching=0

" Tagbar configuration
map <F8> :TagbarToggle<CR>
