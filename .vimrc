" Pretty coloring for vim
au VimEnter *
         \ if &term == 'xterm'           |
         \       set t_Co=256             |
         \ endif

set t_Co=256

" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set nocompatible	        " Use Vim defaults instead of 100% vi compatibility
set backspace=indent,eol,start	" more powerful backspacing
set tabstop=8
set softtabstop=4
set shiftwidth=2
set expandtab

set tabpagemax=100

filetype plugin indent on " load filetype plugins/indent settings


set autochdir " always switch to the current file directory

set wildmenu
set wildignore=*.dll,*.o,*.obj,*.bak,*.exe,*.pyc,*.jpg,*.gif,*.png
set wildmode=list:longest,full

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
syntax on
set hlsearch
hi search guibg=LightGreen guifg=Black cterm=NONE ctermbg=LightCyan ctermfg=Black 
"syntax highlight shell scripts as per POSIX,
"not the original Bourne shell which very few use
let g:is_posix = 1

set background=dark

autocmd FileType python setlocal shiftwidth=4 tabstop=4
autocmd FileType md setlocal shiftwidth=4 tabstop=4
autocmd Filetype tex setlocal nofoldenable
autocmd Filetype tex set cursorline!
autocmd Filetype tex set tw=72
autocmd Filetype tex set spell
autocmd Filetype c,c++,python set cino=(0

"Make the completion menus readable
highlight Pmenu ctermfg=white ctermbg=red guifg=white guibg=red
highlight PmenuSel ctermfg=red ctermbg=white guifg=red guibg=white

" Toggle search pattern highlight
map <silent> <C-n> :set hls!<bar>set hls?<CR>

" <C-tab> to switch tabs
map <C-Tab> :tabn
map <C-S-Tab> :tabp

" Space to scrool up / down
noremap <S-space> <C-b>
noremap <space> <C-f>


" map - 0i// j
" map _ :s/^\s*\/\/ \=//g

" Some nice abbreviations 
" ab #i #include ".h"? ":set hls!

if has("autocmd")
  " When editing a file, always jump to the last known cursor position. 
  " Don't do it when the position is invalid or when inside an event handler 
  " (happens when dropping a file on gvim). 
  autocmd BufReadPost * 
    \ if line("'\"") > 0 && line("'\"") <= line("$") | 
    \   exe "normal g`\"" | 
    \ endif 
endif

" Now we set some defaults for the editor 
set autoindent		" always set autoindenting on
set linebreak		" Don't wrap words by default
set textwidth=0		" Don't wrap lines by default 
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set title

" The following are commented out as they cause vim to behave a lot}}}
" differently from regular Vi. They are highly recommended though.
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set smarttab            " Do smart case matching
set incsearch		" Incremental search
set autowrite		" Automatically save before commands like :next and :make
set hidden             " Hide buffers when they are abandoned
set mouse=a		" Enable mouse usage (all modes) in terminals
set mousemodel=popup
"set spell "spell checking
"set vb t_vb= 
"visual beep
if exists('+colorcolumn')
  set colorcolumn=81
endif

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

if has("gui_gtk2")
  " hi clear CursorLine
  hi CursorLine ctermbg=Black guibg=#1f1f00
  hi CursorColumn ctermbg=Black guibg=#070700
  " gui=underline
  "highlight OverLength ctermbg=red ctermfg=white guibg=#592929
  "match OverLength '\%>81v.\+'



  set guifont=Monospace\ 9
"  set guifont=MiscConsole\ 8
"  set guifont=LucidaSansTypewriter\ 9
else
"    set guifont=-misc-fixed-medium-r-normal--10-100-75-75-c-60-iso8859-1
    set guifont=-*-lucidatypewriter-*-*-*-*-8-*-*-*-*-*-*-*-
    set guifont=Monospace\ 9
endif

highlight Normal guifg=darkgray guibg=black

" Remove menu bar
set guioptions-=m

" Remove toolbar
set guioptions-=T

" VimLatex Settings
" =================
" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
set shellslash

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd BufWritePre *.h,*.c,*.cpp,*.py,*.tex :call <SID>StripTrailingWhitespaces()

setlocal indentexpr=GetMyCIndent()

function! GetMyCIndent()
    let theIndent = cindent(v:lnum)

    let m = matchstr(getline(v:lnum - 1),
    \                '^\s*\w\+\s\+\S\+.*=\s*{\ze[^;]*$')
    if !empty(m)
        let theIndent = len(m)
    endif

    return theIndent
endfunction

"Try to load happy hacking teal colour scheme
"I copy this to ~/.vim/colors/hhteal.vim
if exists("colors_name") == 0
    "Otherwise modify the defaults appropriately

    "background set to dark in .vimrc
    "So pick appropriate defaults.
    hi Normal     guifg=darkgray guibg=black
    hi Visual     gui=none guifg=black guibg=yellow

    "The following removes bold from all highlighting
    "as this is usually rendered badly for me. Note this
    "is not done in .vimrc because bold usually makes
    "the colour brighter on terminals and most terminals
    "allow one to keep the new colour while turning off
    "the actual bolding.

    " Steve Hall wrote this function for me on vim@vim.org
    " See :help attr-list for possible attrs to pass
    function! Highlight_remove_attr(attr)
        " save selection registers
        new
        silent! put

        " get current highlight configuration
        redir @x
        silent! highlight
        redir END
        " open temp buffer
        new
        " paste in
        silent! put x

        " convert to vim syntax (from Mkcolorscheme.vim,
        "   http://vim.sourceforge.net/scripts/script.php?script_id=85)
        " delete empty,"links" and "cleared" lines
        silent! g/^$\| links \| cleared/d
        " join any lines wrapped by the highlight command output
        silent! %s/\n \+/ /
        " remove the xxx's
        silent! %s/ xxx / /
        " add highlight commands
        silent! %s/^/highlight /
        " protect spaces in some font names
        silent! %s/font=\(.*\)/font='\1'/

        " substitute bold with "NONE"
        execute 'silent! %s/' . a:attr . '\([\w,]*\)/NONE\1/geI'
        " yank entire buffer
        normal ggVG
        " copy
        silent! normal "xy
        " run
        execute @x

        " remove temp buffer
        bwipeout!

        " restore selection registers
        silent! normal ggVGy
        bwipeout!
    endfunction
    autocmd BufNewFile,BufRead * call Highlight_remove_attr("bold")
    " Note adding ,Syntax above messes up the syntax loading
    " See :help syntax-loading for more info
endif

