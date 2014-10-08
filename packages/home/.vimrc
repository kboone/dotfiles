""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Kyle Boone's vim config
"
" Required extensions:
" See https://github.com/kboone/dotfiles
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Kill vi compatibility, this isn't 1976
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Load plugins (managed using pathogen)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call pathogen#infect()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Host dependent stuff
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Tab size (default that I use is softtab 4 with hardtabs at 8 spaces)
if !empty(matchstr(hostname(), ".*\.triumf\.ca"))
    " TRIUMF/common physicist config, softtab with 2 spaces per tab, hard tabs
    " are 8
    set expandtab
    set tabstop=8
    set shiftwidth=2
    set softtabstop=2
else
    " Personal config, softtab with 4 spaces per tab, hard tabs are 8
    set expandtab
    set tabstop=8
    set softtabstop=4
    set shiftwidth=4
endif

" troika settings -> make it look reasonable on a 1366x768 screen
if hostname() == "troika"
    if has("gui_running")
        set guifont=Ubuntu\ Mono\ 9
    endif
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable filetype and syntax stuff
syntax on
filetype on
filetype plugin on
filetype indent on

" Update when file is changed externally
set autoread

" Use wildmenu (nice tab completion in command mode)
set wildmenu
set wildmode=list:longest,full

" Incremental searching + highlighting
set incsearch
set hlsearch

" Updated title for vim when run in a terminal
set title

" Don't write backup or swap files (I save often enough... right?)
set nobackup
set noswapfile

" Show where we are in the file
set ruler

" Enable hidden buffers
set hidden

" Text width
set textwidth=80

" Only insert longest common text, show for one line only
" Show preview for completion in python since docstrings are amazing. In most
" other languages it is more of a hindrance.
set completeopt=menu,menuone,longest

" Enable mouse in console version of vim
set mouse=a

" Don't double space. I only like one space after my periods
set nojoinspaces

" Make backspace work properly
set backspace=2

" Log format from cluster search
au BufNewFile,BufRead hst*.log syn match Error "ERROR.*"
au BufNewFile,BufRead hst*.log syn match Type "WARNING.*"
au BufNewFile,BufRead hst*.log syn match Statement "INFO.*"
au BufNewFile,BufRead hst*.log syn match Constant "DEBUG.*"


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Appearance
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable solarized
" Note: If I am getting the weird wrong background bug, this is due to TERM
" being set incorrectly. Doing set t_Co=256 or similar here fixes that, but it
" still breaks inside of tmux. Right now I am setting
" 'TERM=xterm-256color' in .bashrc or .zshrc. It works, but is still wrong.
syntax enable
set background=dark
"let g:solarized_italic=0
colorscheme solarized

" highlight 81st column so that we keep everything within 80. Note, only in 7.3
" or higher
if version > 703
    set colorcolumn=81
endif

if has("gui_running")
    " GUI options

    " Resize the window so that it is 50 lines long
    set lines=50

    " No sound, use visual bell instead
    set visualbell
endif



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Specific language/filetype options
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Python
au FileType python set completeopt+=preview

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General control remaps
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Remap the leader to , since it is much easier than the default \
let mapleader = ","

" Disable alt + key shortcuts in gvim since we can do better
set winaltkeys=no

" ,w: Write in 2 keystrokes instead of 5!
nnoremap <silent> <leader>w :w<CR>

" ,s: Show whitespace toggle
set listchars=tab:>-,trail:�,eol:$
nmap <silent> <leader>s :set nolist!<CR>

" ,O and ,o: Insert blank line above/below
nnoremap <silent> <leader>o :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent> <leader>O :set paste<CR>m`O<Esc>``:set nopaste<CR>

" ,n: Disable highlights
nnoremap <silent> <leader>n :nohl<CR>

" Alt + j/k: Move line up/down
nnoremap <A-k> ddkP
nnoremap <A-j> ddp

" Alt + H/L: move tab right/left
function TabLeft()
    let tab_number = tabpagenr() - 1
    if tab_number == 0
        execute "tabm" tabpagenr('$') - 1
    else
        execute "tabm" tab_number - 1
    endif
endfunction
function TabRight()
    let tab_number = tabpagenr() - 1
    let last_tab_number = tabpagenr('$') - 1
    if tab_number == last_tab_number
        execute "tabm" 0
    else
        execute "tabm" tab_number + 1
    endif
endfunction
map <silent> <A-H> :execute TabLeft()<CR>
map <silent> <A-L> :execute TabRight()<CR>

" Alt + h/l: move to next/previous buffer
map <A-h> :bN!<CR>
map <A-l> :bn!<CR>

" resizing of the full gvim window
" ,1 -> 1 buffer
" ,2 -> 2 buffers
" ,3 -> 1 buffer + taglist
" ,4 -> 2 buffers + taglist
nnoremap <silent> <leader>1 :set columns=80<CR>
nnoremap <silent> <leader>2 :set columns=161<CR>
nnoremap <silent> <leader>3 :set columns=111<CR>
nnoremap <silent> <leader>4 :set columns=192<CR>

" ,ct: Build ctags
nnoremap <silent> <leader>ct :!ctags -R<CR><CR>

" Fix the cursor if it breaks
function FixCursor()
    highlight Cursor NONE
    if has("gui_running")
        highlight Cursor guibg=Green guifg=Black gui=bold
    else
        highlight Cursor cterm=bold ctermfg=0 ctermbg=2
    endif
endfunction

imap <C-Space> <C-x><C-o>

" ,p: Spell check
nnoremap <silent> <leader>p :setlocal spell spelllang=en_us<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Add a c-style name comment for every instance of a string
function Cs(string, comment)
    let regex = "%s/\\(" . a:string . ".*\\)/\\1 \\/\\/ " . a:comment . "/g"
    execute(regex)
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" MiniBufExplorer
" how to use: ,b to open/goto, enter to pick buffer. pops up when more
" than 2 buffers are open by default
map <silent> <leader>b :MiniBufExplorer<CR>
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1
let g:miniBufExplCheckDupeBufs = 0

" TagList
" ,t to open/close. F1 for more info when open
nnoremap <silent> <leader>t :TagbarToggle<CR>

" CtrlP
" hit ,f to find and open files very quickly
nnoremap <silent> <leader>f :CtrlPCurWD<CR>
nnoremap <silent> <leader>F :CtrlPMRUFiles<CR>
nnoremap <silent> <leader>g :CtrlPTag<CR>

" Vim-LaTeX
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"
let g:Tex_DefaultTargetFormat = "pdf"
let g:Tex_MultipleCompileFormats = "pdf"

" The NERD commenter
" Implicit functions:
" ,cc -> comment out line
" ,c<Space> -> toggle comment

" Markdown.vim
let g:vim_markdown_folding_disabled=1
