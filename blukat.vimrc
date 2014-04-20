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
set laststatus=2
hi Statusline cterm=bold,underline ctermfg=White ctermbg=none
hi Visual ctermfg=Black ctermbg=White

" Syntax Deco
hi Comment ctermfg=Blue
hi Constant ctermfg=LightRed
hi PreProc ctermfg=DarkMagenta
hi Special ctermfg=Yellow
hi Statement ctermfg=Green cterm=bold
hi Type ctermfg=DarkCyan cterm=bold 

