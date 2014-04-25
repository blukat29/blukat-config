" Vim
filetype plugin on
set viminfo=

" Programming
set tabstop=2
set expandtab
syntax on
set number
set autoindent
"set tags=~/pintos/src/tags

" Vim Deco
set bg=dark
hi LineNr ctermfg=Yellow
hi Errormsg cterm=bold,underline ctermfg=Red ctermbg=DarkGrey
hi Visual cterm=bold ctermfg=White ctermbg=DarkBlue

" Autocompletion Deco
hi Pmenu ctermfg=Black ctermbg=Green
hi PmenuSel cterm=bold ctermfg=White ctermbg=Red

" Close Omni-Completion tip window when leaving insert mode
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" Statusline Deco
set laststatus=2
set statusline=\ \ %t\ (%{FileSize()})
set statusline+=%4(%m%)%5(%r%)%h
set statusline+=%=%l/%L:%c\ (%P)
set statusline+=\ %15{FileTime()}\ 
hi Statusline cterm=bold,underline ctermfg=White ctermbg=none

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

function! FileTime()
  if getftime(expand('%')) < 0
    return "new file"
  endif
  let tm = localtime() - getftime(expand('%'))
  if tm < 60
    return tm." seconds ago"
  elseif tm < 60*60
    return (tm/60)." minutes ago"
  elseif tm < 60*60*24
    return (tm/60/60)." hours ago"
  elseif tm < 60*60*24*14
    return (tm/60/60/24)." days ago"
  elseif tm < 60*60*24*60
    return (tm/60/60/24/7)." weeks ago"
  else
    return " 2 months or older"
  endif
endfunction

