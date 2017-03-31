" vimrc                                                  last revision: 03-27-17
" Justin Gifford

" Plugins {{{ ------------------------------------------------------------

" Vundle is used to manage plugins.
" Common Vundle commands:
"   :PluginList         - list configured plugins
"   :PluginInstall      - installs plugins
"   :PluginUpdate       - updates plugins
"   :PluginSearch foo   - searches for plugin 'foo'
"   :PluginSearch!      - refresh local cache
"   :PluginClean        - confirms removal of unused plugins
"
" see :h vundle for more help

" required for Vundle
set nocp 
filetype off

" initialize Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" declare plugins (must be between vundle#begin/end)
Plugin 'VundleVim/Vundle.vim'
Plugin 'chriskempson/base16-vim'

call vundle#end()
filetype on
filetype plugin indent on

" syntastic

"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0

" NERDTree

"let g:NERDTreeDirArrowExpandable = '▸'
"let g:NERDTreeDirArrowCollapsible = '▾'

"let g:NERDTreeIgnore = ['\.pyc$', '\~$']


" SuperTab

"let g:SuperTabNoCompleteAfter = ['^',',','\s',';','{','}','[',']']

" vim-devicons
"set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/

" open NERDTree
"noremap <C-n> :NERDTreeToggle<CR>

" toggle Tagbar
"nnoremap <Leader>t :TagbarToggle<CR>

" }}}
" Colors {{{ -------------------------------------------------------------
set background=dark         " set theme to dark
syntax enable               " enable syntax highlighting
set colorcolumn=+1          " highlight the next column after textwidth 

" update base16 colors
if filereadable(expand("~/.vimrc_background"))
    let base16colorspace=256
    source ~/.vimrc_background
endif
colorscheme base16-tomorrow-night

" }}}
" Status Line {{{ --------------------------------------------------------------
set laststatus=2        " always display the status bar

" }}}
" Tab Line {{{ -----------------------------------------------------------------
set showtabline=2           " always show tabline
set tabline=%!BufferLine()
" }}}
" Misc {{{ ---------------------------------------------------------------------
set backspace=indent,eol,start
"set title
set history=1000
set viminfo='500,f1,<100,:100,h,

" }}}
" Leader Bindings {{{ ----------------------------------------------------------

let mapleader="\<Space>"

" reload vimrc
nnoremap <leader>r :source ~/.vimrc<cr>

" call SmartClose() (see custom functions) 
nnoremap <leader>q :call SmartClose()<cr>

" save 
nnoremap <leader>w :w<cr>

" insert a tab
nnoremap <leader><tab> i<tab><esc>l

" insert single character
nnoremap <leader>i i_<esc>r
nnoremap <leader>I I_<esc>r
nnoremap <leader>a a_<esc>r
nnoremap <leader>A A_<esc>r

" insert a line below/above
nnoremap <leader>o o<esc>
nnoremap <leader>O O<esc>

" delete and store text in the _ register
nnoremap <leader>x "_x
nnoremap <leader>X "_X
nnoremap <leader>d "_d
nnoremap <leader>D "_D
nnoremap <leader>dd "_dd
nnoremap <leader>c "_c
nnoremap <leader>C "_C
nnoremap <leader>cc "_cc
nnoremap <leader>s "_s
nnoremap <leader>S "_S

" move to next/previous buffer
nnoremap <leader>l :bnext<cr>
nnoremap <leader>h :bprevious<cr>

" show all open buffers and their state
nnoremap <leader>bl :ls<cr>

" repeat last macro
nnoremap <leader>2 @@

" }}}
" Movement {{{ -----------------------------------------------------------------

" disable arrow keys
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>

" move vertically by visual line
nnoremap j gj
nnoremap k gk

" move to beginning/end of line
nnoremap B ^
nnoremap E $

" }}}
" Spaces and Tabs {{{ ----------------------------------------------------------
set tabstop=4	        " number of visual spaces per tab
set softtabstop=4       " number of spaces in tab when editing
set expandtab	        " tabs are spaces
"set autoindent          " new lines inherit the indentation of previous lines
set smartindent         " smart autoindent a new line
set modelines=1         " check the first and last line for custom vim settings
filetype indent on      " load filetype specific indent files
filetype plugin on

" }}}
" User Interface {{{ -----------------------------------------------------------
set encoding=utf-8      " use unicode encoding
set ruler               " alwys show cursor location
set wildmenu            " visual autocomplete for command menu
set number              " show line numbers
set cursorline          " highlight current line
set scrolloff=5         " keep a minimum of 5 lines above and below cursor
set linebreak           " avoid wrapping a line in the middle of a word
set textwidth=80        " the buffer is 80 characters wide
set showcmd             " show command in bottom bar
set showmatch           " highlight matching {[()]}
set noerrorbells        " disable error beeps
set hidden              " allow buffers to be hidden if modified
set lazyredraw          " don't redraw during macro and script execution
set wildmode=list:longest

" defines what invisible characters are visible if :set list is used
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
" }}}
" Search {{{ -------------------------------------------------------------------
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
set smartcase           " case-sensitive search only if upper-case letter exists
set ignorecase

" <ldr+/> turn off search highlighting
nnoremap <silent> <leader>/ :silent :noh<CR>

" }}}
" Folding {{{ ------------------------------------------------------------------
set foldnestmax=10      " maximium of 10 nested folds allowed
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldcolumn=1        " add column to indicate folds
set foldmethod=indent   " fold based on indention level

" toggle fold and recursive fold
nnoremap <leader><space> za
nnoremap <leader>Z zA

" }}}
" Commands & Misc Bindings {{{ -------------------------------------------------
" jk escapes insert mode
inoremap jk <esc>l

" <F1,2,3> set view mode
nnoremap <F1> :call SetViewMode(1)<cr>
nnoremap <F2> :call SetViewMode(2)<cr>
nnoremap <F3> :call SetViewMode(3)<cr>

" <F5> toggle paste mode
set pastetoggle=<F5>

" command ':H topic' will open the help page for topic in a new buffer
command! -nargs=1 H execute "help <args> | silent! only | set buflisted"

" }}}
" Autogroups {{{ ---------------------------------------------------------------
"augroup configgroup
"    autocmd!
"    autocmd BufNewFile,BufRead *.pl set filetype=prolog
"    autocmd FileType html setlocal set tabstop=2
"    autocmd FileType html setlocal set softtabstop=2
"augroup END

" }}}
" Custom Functions {{{ ---------------------------------------------------------

" Smart Close {{{
" quit based on the following rules:
"  - only one buffer open: quit vim
"  - more than one buffer open: close current buffer, move to the previous one 
function! SmartClose()
    let buf_cnt = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
    if buf_cnt > 1
        execute 'bp'
        execute 'bd #'
    else
        execute 'q'
    endif
endfunction
" }}}
" View Mode {{{
let g:vmode_opts = {1: {'mode': 'normal',  'n': 1, 'f': 1, 's': 2, 't': 2},
                  \ 2: {'mode': 'compact', 'n': 0, 'f': 0, 's': 2, 't': 2},
                  \ 3: {'mode': 'minimal', 'n': 0, 'f': 0, 's': 0, 't': 0}}

function! UpdateViewMode()
    let g:vmode = get(g:, 'vmode', 'vmode_opts[1]')
    echo "View mode set to " . g:vmode['mode']
    if g:vmode['n'] == 1 
        set number 
    else
        set nonumber
    endif
    let &l:foldcolumn  = g:vmode['f']
    let &l:laststatus  = g:vmode['s']
    let &l:showtabline = g:vmode['t']
endfunction

function! SetViewMode(vmode_idx)
    if a:vmode_idx < 1 || a:vmode_idx > 3
        echo "Invalid View Mode " . a:vmode_idx
    else
        let g:vmode = g:vmode_opts[a:vmode_idx]
        call UpdateViewMode()
    endif
endfunction
" }}}
" Buffer Line {{{
" return a list of all listed buffers
function! GetListedBuffers()
    let bufall = range(1, bufnr('$'))
    let buflist = []
    for b in bufall
        if buflisted(b)
            call add(buflist, bufname(b))
        endif
    endfor
    return buflist
endfunction

" display list of open buffers in tabline
function! BufferLine()
    let s = ''
    let tabnr = tabpagenr('$')                  " number of current tab page
    let winnr = tabpagewinnr(tabnr)             " number of current window
    let buflist = GetListedBuffers()

    for bufnr in buflist                        " bufnr is number of buffer
        let bufname = bufname(bufnr)            " name of bufnr
        let bufmod = getbufvar(bufnr, "&mod")   " has bufnr been modified

        let s .= (bufname == @% ? '%#TabLineSel# ' : '%#TabLine# ')
        let s .= (bufname != '' ? fnamemodify(bufname, ':t') : '[No Name]') . ' '

        if bufmod
            let s .= '+ '
        endif
    endfor
    
    let s .= '%#TabLineFill#'
    return s
endfunction
" }}}
" }}}

" vim:foldmethod=marker:foldlevel=0
