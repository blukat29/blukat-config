
" Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/vundle.vim'
Plugin 'taglist.vim'
Plugin 'xolox/vim-misc.git'
Plugin 'easytags.vim'
call vundle#end()
filetype plugin indent on

" General
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent
syntax on
set number
set nuw=5
set hlsearch
set tags=~/pintos/src/tags
set nowrap
set viminfo="NONE"

" Python specific tab settings.
autocmd BufNewFile,BufRead *.wsgi set filetype=python
autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4

" Close Omni-Completion tip window when leaving insert mode
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

" <Ctrl-m> selects code block inside matching parenthesis.
nmap <C-m> v%<CR>

" TagList
nnoremap <silent> <F8> :TlistToggle<CR>
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_Right_Window = 1
let Tlist_Show_One_File = 1

" Easytags
let g:easytags_dynamic_files = 1
let g:easytags_events = ['BufWritePost','VimEnter','BufEnter','Winenter']

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

  hi CursorLine cterm=none ctermbg=233
  hi Question cterm=bold,underline ctermfg=Cyan

  colorscheme default

  hi Comment ctermfg=blue
  hi LineNr ctermfg=248
  hi ErrorMsg cterm=bold,underline ctermfg=Red ctermbg=none
  hi WarningMsg cterm=bold,underline ctermfg=Red ctermbg=none
  hi Visual cterm=bold ctermbg=236
  hi Search cterm=bold ctermfg=White ctermbg=DarkBlue
  hi StatusLine cterm=bold,underline ctermfg=119 ctermbg=232
  hi StatusLineNC cterm=bold,underline ctermfg=244 ctermbg=232
  hi Pmenu ctermfg=Grey
  hi PmenuSel ctermfg=Black
  hi VertSplit cterm=none ctermfg=248 ctermbg=236
  hi FoldColumn ctermfg=119 ctermbg=236

else
 
  hi clear
  colorscheme default

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

