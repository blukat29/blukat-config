" Programming
set tabstop=2
set expandtab
syntax on
set number
set autoindent
"set tags=~/pintos/src/tags
filetype plugin on

" Vim Deco
set bg=dark
hi LineNr ctermfg=Yellow
hi Errormsg cterm=bold,underline ctermfg=Red ctermbg=DarkGrey

" Syntax Deco
hi Comment ctermfg=Blue
hi Constant ctermfg=LightRed
hi PreProc ctermfg=DarkMagenta
hi Special ctermfg=Yellow
hi Statement ctermfg=Green cterm=bold
hi Type ctermfg=DarkCyan cterm=bold 

" Putty + Windows style cursor movement
map <ESC>[C w
map <ESC>[D b
imap <ESC>[C <C-O>w
imap <ESC>[D <C-O>b

map <ESC>[A H
map <ESC>[B L
imap <ESC>[A <C-O>H
imap <ESC>[B <C-O>L

