"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Kyle Boone's vim config
"
" Do the following things to get this up and running:
"
" Download/update installed modules:
" :PluginInstall
"
" Add pep8 support in syntastic:
" pip install flake8
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Necessary settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" First, set the encoding. We have some utf-8 characters in this file.
scriptencoding utf-8

" Next, specify that the vim shell should be bash in case the login shell is
" something different... most plugins assume that they are being run in bash
" and break of the login shell is e.g. fish.
set shell=/bin/bash

" Kill vi compatibility, this isn't 1976 and we want nice plugins.
set nocompatible


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins (managed using Vundle)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Load Vundle which manages our plugins
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

" General syntax and completion
Plugin 'majutsushi/tagbar'
Plugin 'scrooloose/syntastic'
Plugin 'ervandew/supertab'

" Appearance
Plugin 'kboone/vim-colors-solarized'
Plugin 'vim-airline/vim-airline'
Plugin 'kboone/vim-airline-themes'
Plugin 'edkolev/tmuxline.vim'

" Text editing
Plugin 'scrooloose/nerdcommenter'
Plugin 'tpope/vim-surround'
Plugin 'godlygeek/tabular'

" Filetype specific plugins
Plugin 'hynek/vim-python-pep8-indent'
Plugin 'LaTeX-Box-Team/LaTeX-Box'

" Files/buffers
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'fholgado/minibufexpl.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-fugitive'
Plugin 'christoomey/vim-tmux-navigator'

" End of plugins
call vundle#end()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" PEP8 style tabs and line wrapping.
" 4 spaces per tab, expand tabs as spaces.
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
" text by default)
set backspace=2

" Don't redraw in the middle of macros
set lazyredraw


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Appearance
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Use the solarized colorscheme
" Note: If I am getting the weird wrong background bug, this is due to TERM
" being set incorrectly. Doing set t_Co=256 or similar here fixes that, but it
" still breaks inside of tmux. The fix is to set 'TERM=xterm-256color' in
" .bashrc or .zshrc. This should only be done if the terminal is known to
" support colors!
syntax on
set background=dark
colorscheme solarized

" Show line numbers, and where we are in the file
set number
set ruler

" Update the title when running in a terminal
set title

" Show line breaks
set showbreak=↪\ \ \ 
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
set listchars=tab:>-,trail:·,eol:$
nmap <silent> <leader>s :set nolist!<CR>

" ,n: Disable highlights
nnoremap <silent> <leader>n :nohl<CR>

" resizing of the full gvim window
" ,1 -> 1 buffer
" ,2 -> 2 buffers
" ,3 -> 1 buffer + taglist
" ,4 -> 2 buffers + taglist
nnoremap <silent> <leader>1 :set columns=80<CR>
nnoremap <silent> <leader>2 :set columns=160<CR>
nnoremap <silent> <leader>3 :set columns=110<CR>
nnoremap <silent> <leader>4 :set columns=190<CR>

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
