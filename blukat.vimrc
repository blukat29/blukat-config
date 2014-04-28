" Vim
filetype plugin on
set viminfo=

" General
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent
syntax on
set number
set nuw=5
set hlsearch
"set tags=~/pintos/src/tags

" Close Omni-Completion tip window when leaving insert mode
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

" Statusline
set laststatus=2
set statusline=\ %{FileName()}\ %<(%{FileSize()})
set statusline+=%4(%m%)%5(%r%)%7(%h%)
set statusline+=%=%l/%L\ (%P)
set statusline+=\ %15{FileTime()}\ 

" Coloring 
if &term == "xterm" || &term == "screen"

  hi clear
  set t_Co=256
  set cursorline

  hi LineNr ctermfg=248 ctermbg=232
  hi ErrorMsg cterm=bold,underline ctermfg=Red ctermbg=none
  hi WarningMsg cterm=bold,underline ctermfg=Red ctermbg=none
  hi Visual cterm=bold ctermfg=White ctermbg=DarkBlue
  hi CursorLine cterm=none ctermbg=233
  hi Pmenu ctermfg=Black ctermbg=Green
  hi PmenuSel cterm=bold ctermfg=White ctermbg=Red
  hi Search cterm=bold ctermfg=White ctermbg=Magenta
  hi StatusLine cterm=bold,underline ctermfg=119 ctermbg=236
  hi StatusLineNC cterm=bold,underline ctermfg=244 ctermbg=236
  hi Question cterm=bold,underline ctermfg=Cyan
  hi VertSplit cterm=none ctermbg=236

  hi FoldColumn ctermfg=yellow ctermbg=236
  hi Folded cterm=underline ctermfg=yellow ctermbg=236
  hi DiffAdd ctermbg=22
  hi DiffDelete ctermfg=52 ctermbg=52
  hi DiffChange ctermbg=17
  hi DiffText ctermbg=19

  hi Normal ctermfg=251
  hi Comment ctermfg=Blue
  hi Constant ctermfg=9
  hi Number ctermfg=9
  hi String ctermfg=9
  hi PreProc ctermfg=Magenta
  hi Special ctermfg=Yellow
  hi Statement ctermfg=Green cterm=bold
  hi Type ctermfg=DarkCyan cterm=bold

else

  hi clear

  hi LineNr ctermfg=Yellow
  hi ErrorMsg cterm=bold,underline ctermfg=Red ctermbg=black
  hi WarningMsg cterm=bold,underline ctermfg=Red ctermbg=black
  hi Visual cterm=bold ctermfg=White ctermbg=DarkBlue
  hi Pmenu ctermfg=Black ctermbg=Green
  hi PmenuSel cterm=bold ctermfg=White ctermbg=Red
  hi Search cterm=bold ctermfg=White ctermbg=LightMagenta
  hi StatusLine cterm=bold,underline ctermfg=white ctermbg=none

  hi Comment ctermfg=Blue
  hi Constant ctermfg=LightRed
  hi PreProc ctermfg=Magenta
  hi Special ctermfg=Yellow
  hi Statement ctermfg=Green cterm=bold
  hi Type ctermfg=DarkCyan cterm=bold

endif

" Functions
function! FileName()
  let fn = expand('%')
  if fn == ""
    return "[nonamed]" 
  else
    return split(resolve(fn), '/')[-1]
  endif
endfunction

function! FileSize()
  let bytes = getfsize(expand("%:p"))
  if bytes <= 0
    return "0B"
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

