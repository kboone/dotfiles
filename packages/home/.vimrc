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

if has('nvim')
    if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
        silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
            \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
            autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
else
    if empty(glob('~/.vim/autoload/plug.vim'))
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
            \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
endif

" Load vim-plug which manages our plugins
call plug#begin()

" General code browsing
Plug 'preservim/tagbar'

" Appearance
Plug 'joshdick/onedark.vim'
Plug 'itchyny/lightline.vim'
Plug 'edkolev/tmuxline.vim'

" Text editing
Plug 'preservim/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular'

" Filetype specific plugins
Plug 'Vimjas/vim-python-pep8-indent'

" Files/buffers
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'fholgado/minibufexpl.vim'
Plug 'preservim/nerdtree'
Plug 'christoomey/vim-tmux-navigator'

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
set textwidth=88

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
set nowritebackup

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

" don't give |ins-completion-menu| messages.
set shortmess+=c

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

" Use 24-bit RGB colors
if (has("termguicolors"))
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif


" Use the onedark colorscheme
syntax on
colorscheme onedark

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

" Highlight 89th column so that we keep everything within 88. Note, only in 7.3
" or higher
if version > 703
    set colorcolumn=89
endif

if has("gui_running")
    " GUI options

    " Resize the window so that it is 50 lines long
    set lines=50

    " No sound, use visual bell instead
    set visualbell
endif

" Use a vertical line for the cursor in insert mode
if has("autocmd")
  au VimEnter,InsertLeave * silent execute '!echo -ne "\e[2 q"'
  au InsertEnter,InsertChange *
    \ if v:insertmode == 'i' |
    \   silent execute '!echo -ne "\e[6 q"' |
    \ elseif v:insertmode == 'r' |
    \   silent execute '!echo -ne "\e[4 q"' |
    \ endif
  au VimLeave * silent execute '!echo -ne "\e[ q"'
endif

" Use a better vertical split character
set fillchars+=vert:│


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

" move vertically by visual line instead of physical line
nnoremap j gj
nnoremap k gk

" Yank and paste to the X-windows primary selection
set clipboard=unnamed

" ,z: close the preview window
nnoremap <silent> <leader>z :pclose<CR>

" Ctrl + N/P to move along the buffer list.
nnoremap <silent> <C-N> :bnext<CR>
nnoremap <silent> <C-P> :bprev<CR>

" ,r: Force a redraw on the screen.
nnoremap <silent> <leader>r :redraw!<CR>

" wrap :cnext/:cprevious and :lnext/:lprevious
function! WrapCommand(direction, prefix)
    if a:direction == "up"
        try
            execute a:prefix . "previous"
        catch /^Vim\%((\a\+)\)\=:E553/
            execute a:prefix . "last"
        catch /^Vim\%((\a\+)\)\=:E\%(776\|42\):/
        endtry
    elseif a:direction == "down"
        try
            execute a:prefix . "next"
        catch /^Vim\%((\a\+)\)\=:E553/
            execute a:prefix . "first"
        catch /^Vim\%((\a\+)\)\=:E\%(776\|42\):/
        endtry
    endif
endfunction

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


" FZF
" ,f to find and open files very quickly
" ,F to search recent files
" ,h to search tags
" ,b to search buffers
nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>b :Buffers<CR>

" The NERD commenter
" Implicit functions:
" ,cc -> comment out line
" ,c<Space> -> toggle comment

" vim-lightline
set laststatus=2

" lightline colorscheme. This is normally in a separate file, but I include it here so
" that we don't have to manage extra files.
let s:colors = onedark#GetColors()

if get(g:, 'onedark_termcolors', 256) == 16
  let s:term_red = s:colors.red.cterm16
  let s:term_green = s:colors.green.cterm16
  let s:term_yellow = s:colors.yellow.cterm16
  let s:term_blue = s:colors.blue.cterm16
  let s:term_purple = s:colors.purple.cterm16
  let s:term_white = s:colors.white.cterm16
  let s:term_cursor_grey = s:colors.cursor_grey.cterm16
  let s:term_visual_grey = s:colors.visual_grey.cterm16
else
  let s:term_red = s:colors.red.cterm
  let s:term_green = s:colors.green.cterm
  let s:term_yellow = s:colors.yellow.cterm
  let s:term_blue = s:colors.blue.cterm
  let s:term_purple = s:colors.purple.cterm
  let s:term_white = s:colors.white.cterm
  let s:term_cursor_grey = s:colors.cursor_grey.cterm
  let s:term_visual_grey = s:colors.visual_grey.cterm
endif

let s:red = [ s:colors.red.gui, s:term_red ]
let s:green = [ s:colors.green.gui, s:term_green ]
let s:yellow = [ s:colors.yellow.gui, s:term_yellow ]
let s:blue = [ s:colors.blue.gui, s:term_blue ]
let s:purple = [ s:colors.purple.gui, s:term_purple ]
let s:white = [ s:colors.white.gui, s:term_white ]
let s:cursor_grey = [ s:colors.cursor_grey.gui, s:term_cursor_grey ]
let s:visual_grey = [ s:colors.visual_grey.gui, s:term_visual_grey ]

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}
let s:p.normal.left = [ [ s:cursor_grey, s:blue ], [ s:white, s:visual_grey ] ]
let s:p.normal.right = [ [ s:cursor_grey, s:blue ], [ s:white, s:visual_grey ] ]
let s:p.inactive.left =  [ [ s:white, s:visual_grey ], [ s:white, s:visual_grey ] ]
let s:p.inactive.right = [ [ s:cursor_grey, s:white ], [ s:cursor_grey, s:white ] ]
let s:p.insert.left = [ [ s:cursor_grey, s:green ], [ s:white, s:visual_grey ] ]
let s:p.insert.right = [ [ s:cursor_grey, s:green ], [ s:white, s:visual_grey ] ]
let s:p.replace.left = [ [ s:cursor_grey, s:red ], [ s:white, s:visual_grey ] ]
let s:p.replace.right = [ [ s:cursor_grey, s:red ], [ s:white, s:visual_grey ] ]
let s:p.visual.left = [ [ s:cursor_grey, s:purple ], [ s:white, s:visual_grey ] ]
let s:p.visual.right = [ [ s:cursor_grey, s:purple ], [ s:white, s:visual_grey ] ]
let s:p.normal.middle = [ [ s:white, s:cursor_grey ] ]
let s:p.inactive.middle = [ [ s:white, s:visual_grey ] ]
let s:p.tabline.left = [ [ s:white, s:visual_grey ] ]
let s:p.tabline.tabsel = [ [ s:cursor_grey, s:white ] ]
let s:p.tabline.middle = [ [ s:white, s:cursor_grey ] ]
let s:p.tabline.right = [ [ s:white, s:visual_grey ] ]
let s:p.normal.error = [ [ s:cursor_grey, s:red ] ]
let s:p.normal.warning = [ [ s:cursor_grey, s:yellow ] ]

let g:lightline#colorscheme#customonedark#palette = lightline#colorscheme#flatten(s:p)

let g:lightline = {
  \ 'colorscheme': 'customonedark',
\ }

" tmuxline
" These settings are saved in ~/.tmuxline.conf. If it gets messed up, it can be
" regenerated using the tmuxline commands:
" :Tmuxline lightline
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
    \ 'right' : '',
    \ 'right_alt' : '',
    \ 'space' : ' '}

" tabular
" :Tab /= -> align on equal sign

" surround
" ysiw) -> add ) around the current word (iw)
" cs'" -> change surrounding ' to "
" ds' -> delete surrounding '

