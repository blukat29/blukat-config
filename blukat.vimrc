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
if &term == "xterm"
  set t_Co=256
elseif &term == "screen"
  set t_Co=256
endif
hi clear
hi LineNr ctermfg=248 ctermbg=232
hi Errormsg cterm=bold,underline ctermfg=Red ctermbg=black
hi Warningmsg cterm=bold,underline ctermfg=Red ctermbg=black
hi Visual cterm=bold ctermfg=White ctermbg=DarkBlue
set cursorline
hi Cursorline cterm=none ctermbg=233

" Autocompletion Deco
hi Pmenu ctermfg=Black ctermbg=Green
hi PmenuSel cterm=bold ctermfg=White ctermbg=Red

" Close Omni-Completion tip window when leaving insert mode
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" Searching deco
set hlsearch
hi Search cterm=bold ctermfg=White ctermbg=Magenta

" Statusline Deco
set laststatus=2
set statusline=\ %{FileName()}\ (%{FileSize()})
set statusline+=%4(%m%)%5(%r%)%h
set statusline+=%=%l/%L\ (%P)
set statusline+=\ %15{FileTime()}\ 
hi Statusline cterm=bold,underline ctermfg=119 ctermbg=236

" Syntax Deco
hi Normal ctermfg=251
hi Comment ctermfg=Blue
hi Constant ctermfg=9
hi Number ctermfg=9
hi String ctermfg=9
hi PreProc ctermfg=Magenta
hi Special ctermfg=Yellow
hi Statement ctermfg=Green cterm=bold
hi Type ctermfg=DarkCyan cterm=bold

" Functions
function! FileName()
  return split(resolve(expand('%')), '/')[-1]
endfunction

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

