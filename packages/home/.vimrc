"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Kyle Boone's vim config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Necessary settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" First, set the encoding. We have some utf-8 characters in this file.
scriptencoding utf-8

" Next, specify that the vim shell should be bash in case the login shell is
" something different... some plugins assume that they are being run in bash
" and break if the login shell is not compatible.
set shell=/bin/bash

" Kill vi compatibility, this isn't 1976 and we want nice plugins.
set nocompatible


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins (managed using vim-plug)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Load vim-plug which manages our plugins
call plug#begin()

" General syntax and completion
Plug 'majutsushi/tagbar'
Plug 'scrooloose/syntastic'
Plug 'Valloric/YouCompleteMe'

" Appearance
Plug 'kboone/vim-colors-solarized'
Plug 'vim-airline/vim-airline'
Plug 'kboone/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'

" Dependencies
Plug 'MarcWeber/vim-addon-mw-utils'       " required by snipmate
Plug 'tomtom/tlib_vim'                    " required by snipmate

" Text editing
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular'
Plug 'garbas/vim-snipmate'
Plug 'honza/vim-snippets'

" Filetype specific plugins
Plug 'hynek/vim-python-pep8-indent'
Plug 'LaTeX-Box-Team/LaTeX-Box'

" Files/buffers
Plug 'ctrlpvim/ctrlp.vim'
Plug 'fholgado/minibufexpl.vim'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'christoomey/vim-tmux-navigator'
Plug 'airblade/vim-gitgutter'

" End of plugins
call plug#end()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" UTF-8 internal encoding
set encoding=utf-8

" PEP8 style tabs and line wrapping.
" 4 spaces per tab, expand tabs as spaces.
set smarttab
set expandtab
set tabstop=8
set softtabstop=4
set shiftwidth=4
set textwidth=79

" Enable filetype and syntax stuff
filetype plugin indent on

" Update when file is changed externally
set autoread

" Use wildmenu (nice tab completion in command mode)
set wildmenu
set wildmode=list:longest,full

" Incremental searching + highlighting
set incsearch
set hlsearch

" Don't write backup or swap files
set nobackup
set noswapfile

" Enable hidden buffers
set hidden

" Enable mouse in console version of vim
set mouse=a
if !has('nvim')
    set ttymouse=xterm2
endif

" Don't double space. I only like one space after my periods
set nojoinspaces

" Make backspace work properly (some older vims only have backspace for new
" text by default). Note that backspace=2 is equivalent to
" backspace=indent,eol,start that most people recommend, but is also compatible
" with very old vims.
set backspace=2

" Don't redraw in the middle of macros
set lazyredraw

" Don't autoscan includes for completion. This is slow, and I use ctags which
" is much better
set complete-=i

" Don't show the preview window. It is too jarring for my liking.
set completeopt-=preview

" Use smart case in searching. This means that all lowercase matches any case,
" but any uppercase characters for an exact case match. Override with \c or \C
" if necessary.
set ignorecase
set smartcase

" Nobody uses octal anymore. 008 comes after 007 for everything that I do.
set nrformats-=octal

" Use a timeout of 100 ms on commands.
set ttimeout
set ttimeoutlen=100

" Handle joining of lines with comments properly.
if v:version > 703 || v:version == 703 && has("patch541")
    set formatoptions+=j
endif

" Increase default lengths. We have plenty of RAM/memory these days.
set history=1000
set tabpagemax=50


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Appearance
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Use my modified solarized colorscheme
syntax on
set background=dark
colorscheme solarized

" Show line numbers, and where we are in the file
set number
set ruler

" Update the title when running in a terminal
set title

" Keep the cursor away from the edges of the screen.
set scrolloff=1
set sidescrolloff=5

" Actually show long last lines instead of just spewing out @ symbols.
set display+=lastline

" Show line breaks
let &showbreak="\u21aa  "
if v:version > 704 || v:version == 704 && has("patch338")
    " Make the breaks indent properly. Available in builds after ~June 2014.
    set breakindent
endif

" Highlight 80th column so that we keep everything within 79. Note, only in 7.3
" or higher
if version > 703
    set colorcolumn=80
endif

" Host dependent stuff
if hostname() == "troika"
    " troika settings -> make it look reasonable on a 1366x768 screen
    if has("gui_running")
        set guifont=Ubuntu\ Mono\ 9
    endif
endif

if has("gui_running")
    " GUI options

    " Resize the window so that it is 50 lines long
    set lines=50

    " No sound, use visual bell instead
    set visualbell
endif

" Log format from cluster search
au BufNewFile,BufRead seechange*.log syn match Error "ERROR.*"
au BufNewFile,BufRead seechange*.log syn match Type "WARNING.*"
au BufNewFile,BufRead seechange*.log syn match Statement "INFO.*"
au BufNewFile,BufRead seechange*.log syn match Constant "DEBUG.*"


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General control remaps
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Remap the leader to , since it is much easier than the default \
let mapleader = ","
let maplocalleader = ","

" Disable alt + key shortcuts in gvim since we can do better
set winaltkeys=no

" ,s: Show whitespace toggle
set listchars=tab:>-,trail:·,eol:$,extends:>,precedes:<
nmap <silent> <leader>s :set nolist!<CR>

" ,n: Disable highlights
nnoremap <silent> <leader>n :nohl<CR>

" ,ct: Build ctags
nnoremap <silent> <leader>ct :!ctags -R<CR><CR>

" disabled, was ,p: Spell check
" nnoremap <silent> <leader>p :setlocal spell spelllang=en_us<CR>

" move vertically by visual line instead of physical line
nnoremap j gj
nnoremap k gk

" ,y and ,p: yank and paste from x clipboard
nnoremap <silent> <leader>y "+y
nnoremap <silent> <leader>p "+p

" ,z: close the preview window
nnoremap <silent> <leader>z :pclose<CR>

" Ctrl + N/P to move along the buffer list.
nnoremap <silent> <C-N> :bnext<CR>
nnoremap <silent> <C-P> :bprev<CR>

" ,r: Force a redraw on the screen.
nnoremap <silent> <leader>r :redraw!<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" MiniBufExplorer
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1
let g:miniBufExplCheckDupeBufs = 0

" Tagbar
" ,t to open/close. F1 for more info when open
" For vim, use the latex-box viewer instead which is better.
nnoremap <silent> <leader>t :TagbarToggle<CR>
let g:tagbar_sort = 0
autocmd FileType tex nnoremap <silent> <leader>t :LatexTOCToggle<CR>


" CtrlP
" ,f to find and open files very quickly
" ,F to search recent files
" ,h to search tags
" ,b to search buffers
let g:ctrlp_map = ''
nnoremap <silent> <leader>f :CtrlPCurWD<CR>
nnoremap <silent> <leader>F :CtrlPMRUFiles<CR>
nnoremap <silent> <leader>h :CtrlPTag<CR>
nnoremap <silent> <leader>b :CtrlPBuffer<CR>

" Vim-LaTeX
" set grepprg=grep\ -nH\ $*
" let g:tex_flavor = "latex"
" let g:Tex_DefaultTargetFormat = "pdf"
" let g:Tex_MultipleCompileFormats = "pdf"

" The NERD commenter
" Implicit functions:
" ,cc -> comment out line
" ,c<Space> -> toggle comment

" vim-airline
set laststatus=2
let g:airline_theme = "kyle"
let g:airline_powerline_fonts = 1

" tmuxline
" These settings are saved in ~/.tmuxline.conf. If it gets messed up, it can be
" regenerated using the tmuxline commands:
" :Tmuxline airline
" :TmuxlineSnapshot ~/.tmuxline.conf
let g:tmuxline_powerline_separators = 1
let g:tmuxline_preset = {
      \'win'  : '#I:#W',
      \'cwin' : '#I:#W',
      \'y'    : ['#H'],
      \'options' : {'status-justify': 'left'}}
let g:tmuxline_separators = {
    \ 'left' : '',
    \ 'left_alt': '',
    \ 'right' : '',
    \ 'right_alt' : '',
    \ 'space' : ' '}

" tabular
" :Tab /= -> align on equal sign

" surround
" ysiw) -> add ) around the current word (iw)
" cs'" -> change surrounding ' to "
" ds' -> delete surrounding '

" fugitive
" ,ga -> git add [current file]
nnoremap <leader>ga :Git add %:p<CR><CR>
" ,gc -> git commit
nnoremap <leader>gc :Gcommit -q<CR>
" ,gt -> git commit current file
nnoremap <leader>gt :Gcommit -q %:p<CR>
" ,gp -> git push
nnoremap <leader>gp :Gpush<CR>
" ,gu -> git pull
nnoremap <leader>gu :Gpull<CR>

" vim-tmux-navigator
" BUG: vim-tmux-navigator uses ctrl+j to move to the next window down. If
" syntastic was just run and ctrl+j is pressed while vim is hanging, it is
" interpreted as a line feed character and the display shifts a line. A hacky
" fix is to force a full redraw whenever ctrl+j is pressed.
autocmd VimEnter * nnoremap <silent> <c-j> :TmuxNavigateDown<cr>:redraw!<cr>

" YouCompleteMe
" ,d -> go to definition
nnoremap <leader>d :YcmCompleter GoTo<CR>
" ,i -> get doc
nnoremap <leader>i :YcmCompleter GetDoc<CR>
" Use the python on the path for YCM. This lets us use whichever anaconda
" environment we want.
let g:ycm_python_binary_path = system('which python | tr -d "\n"')
