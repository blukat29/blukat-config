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
hi Visual cterm=bold ctermfg=White ctermbg=DarkBlue

" Statusline Deco
set laststatus=2
hi Statusline cterm=bold,underline ctermfg=White ctermbg=none
set statusline=\ \ %t\ (%{FileSize()})
set statusline+=%4(%m%)%5(%r%)%h
set statusline+=%=%l/%L:%c\ (%P)
set statusline+=\ %{strftime('%m/%d\ %2H:%M:%S',getftime(expand('%')))}

" Syntax Deco
hi Comment ctermfg=Blue
hi Constant ctermfg=LightRed
hi PreProc ctermfg=DarkMagenta
hi Special ctermfg=Yellow
hi Statement ctermfg=Green cterm=bold
hi Type ctermfg=DarkCyan cterm=bold 

" Functions
function! FileSize()
  let bytes = getfsize(expand("%:p"))
  if bytes <= 0
    return "empty"
  endif
  if bytes<1024
    return bytes."B"
  else
    return (bytes/1024)."KB"
  endif
endfunction

