"----------------------------
"-Author:easy               -
"-Time:2016/10/10           -
"----------------------------

"Judge current system
if has("win32") || has("win32unix")
    let g:OS#name = "win"
    let g:OS#win = 1
    let g:OS#mac = 0
    let g:OS#unix = 0
elseif has("mac")
    let g:OS#name = "mac"
    let g:OS#mac = 1
    let g:OS#win = 0
    let g:OS#unix = 0
elseif has("unix")
    let g:OS#name = "unix"
    let g:OS#unix = 1
    let g:OS#win = 0
    let g:OS#mac = 0
endif
if has("gui_running")
    let g:OS#gui = 1
else
    let g:OS#gui = 0
endif

"Set user path
if g:OS#win
    "let $VIUMFILES = $VIM.'/vimfiles'
    "let $HOME = $VIUMFILES
elseif g:OS#unix
    let $VIM = $HOME
    let $VIMFILES = $HOME.'~/.vim'
elseif g:OS#mac
    let $VIM = $HOME
    let $VIMFILES = $HOME.'~/.vim'
endif


if g:OS#win
	 " MyDiff 
	set diffexpr=MyDiff()
	function! MyDiff()
		  let opt = '-a --binary '
		  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
		  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
		  let arg1 = v:fname_in
		  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
		  let arg2 = v:fname_new
		  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
		  let arg3 = v:fname_out
		  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
		  let eq = ''
		  if $VIMRUNTIME =~ ' '
			if &sh =~ '\<cmd'
			  let cmd = '""' . $VIMRUNTIME . '\diff"'
			  let eq = '"'
			else
			  let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
			endif
		  else
			let cmd = $VIMRUNTIME . '\diff'
		  endif
		  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
	endfunction
endif

" Win平台下窗口全屏组件 gvimfullscreen.dll
" Alt + Enter 全屏切换
" Shift + t 降低窗口透明度
" Shift + y 加大窗口透明度
" Shift + r 切换Vim是否总在最前面显示
" Vim启动的时候自动使用当前颜色的背景色以去除Vim的白色边框
if has('gui_running') && has('gui_win32') && has('libcall')
    let g:MyVimLib = 'gvimfullscreen.dll'
    function! ToggleFullScreen()
        call libcall(g:MyVimLib, 'ToggleFullScreen', 1)
    endfunction

    let g:VimAlpha = 255
    function! SetAlpha(alpha)
        let g:VimAlpha = g:VimAlpha + a:alpha
        if g:VimAlpha < 180
            let g:VimAlpha = 180
        endif
        if g:VimAlpha > 255
            let g:VimAlpha = 255
        endif
        call libcall(g:MyVimLib, 'SetAlpha', g:VimAlpha)
    endfunction

    let g:VimTopMost = 0
    function! SwitchVimTopMostMode()
        if g:VimTopMost == 0
            let g:VimTopMost = 1
        else
            let g:VimTopMost = 0
        endif
        call libcall(g:MyVimLib, 'EnableTopMost', g:VimTopMost)
    endfunction

    "Map Alt+Enter switch to all screen
    map <a-enter> <esc>:call ToggleFullScreen()<cr>
    
    "Map Shift+r switch to if the Vim is topmost
    nmap <s-r> <esc>:call SwitchVimTopMostMode()<cr>

    "Add the alpha of Vim's window
    nmap <s-t> <esc>:call SetAlpha(10)<cr>

    "Add the alpha of Vim's window
    nmap <s-y> <esc>:call SetAlpha(-10)<cr>
    
    " Set the alpha defult
    autocmd GUIEnter * call libcallnr(g:MyVimLib, 'SetAlpha', g:VimAlpha)
endif

"---vundle
"------------------------------------------------------------------
set nocompatible 
filetype on
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

"my vundle 
Plugin 'vim-airline/vim-airline'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'eugeii/consolas-powerline-vim'
Plugin 'scrooloose/nerdtree'

"Color schemes
Plugin 'tomasr/molokai'
Plugin 'Lucius'
Plugin 'altercation/solarized'
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'flazz/vim-colorschemes'

"YouCompleteMe
Plugin 'Valloric/YouCompleteMe'
"Syntastic
Plugin 'scrooloose/syntastic'
"ListToggle
"Plugin 'Valloric/ListToggle'

call vundle#end()
filetype plugin indent on

"------------------------------------------------------------------
"----Airline
"------------------------------------------------------------------
"Set powerline fonts
let g:airline_theme="luna"
"Enable tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
"Set buffer map
nnoremap <C-tab> :bn<CR>
nnoremap <C-s-tab> :bp<CR>
"Must set after install fonts
let g:airline_powerline_fonts = 1
"Solve garbage characters and show fonts
let g:Powerline_symbols = 'fancy'
set guifont=Droid_Sans_Mono_Slashed_for_Pow:h12:cANSI:qDRAFT
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,utf-16,gbk,big5,gb18030,latin1

set laststatus=2

"Config powerline symbols
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''


"------------------------------------------------------------------
"---Copy paste
"------------------------------------------------------------------
nmap ,v "+p
vmap ,c "+yy
nmap ,c "+yy

"Set colorschemes
"colorscheme molokai
"colorscheme Lucius
colorscheme solarized
"colorscheme PaperColor

"Enable syntax light
syntax enable
syntax on

"Set tab length
set tabstop=4

"Set auto indentation
set shiftwidth=4
set softtabstop=4
set autoindent
set expandtab

"Set line number
set number

"Hide menu
set guioptions-=m
"Hide toolbar
set guioptions-=T
"Hide left scroll bar
set guioptions-=L
"Hide right scroll bar
set guioptions-=r
"Hide bottom scroll bar
set guioptions-=b
"Hide tabline
"set showtabline=0

"Set no undo file
set noundofile
"Set no ~ file
set nobackup
"Set no swapfile
set noswapfile

"Set no ^M
if g:OS#win
    set fileformats=dos
endif

"Set auto fill
function! AutoPair(open, close)
  let line = getline('.')
  if col('.') > strlen(line) || line[col('.') - 1] == ' '
    return a:open.a:close."\<ESC>i"
  else
    return a:open
  endif
endf
function ClosePair(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endf

inoremap ( <c-r>=AutoPair('(', ')')<CR>
inoremap ) <c-r>=ClosePair(')')<CR>
inoremap { {}<ESC>i
inoremap } <c-r>=ClosePair('}')<CR>
inoremap [ []<ESC>i
inoremap ] <c-r>=ClosePair(']')<CR>
inoremap < <><ESC>i
inoremap > <c-r>=ClosePair('>')<CR>

"Set template
"autocmd BufNewFile *.txt 0r ~/.vim/template/txt.tlp
"let g:Timestamp = .strftime("%Y-%m-%d %H:%M")
"Txt
function InputTimestamp()
    call append(0,"Timestamp: ".strftime("%Y-%m-%d %H:%M"))
endf
function LoadTemplate()
    if &filetype == 'text'
        call InputTimestamp()
    endif
    if &filetype == 'markdown'
        call append(0,"title: ")
        call append(1,"date: ".strftime("%Y-%m-%d %H:%M"))
        call append(2,"update: ".strftime("%Y-%m-%d %H:%M"))
        call append(3,"comments: true")
        call append(4,"tags: ")
        call append(5,"categories: ")
        call append(6,"---")
    endif
endf
function UpdateTimestamp()
endf
autocmd BufNewFile * call LoadTemplate()
"Md

"Cs
"Lua
"C
"Cpp
"Js

"Set up down left right disabled
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

"Set winpos
winpos 800 335

"Set search
set hlsearch
set incsearch
set ignorecase

"Set map
function SetTxtMap()
    "Timestamp
    noremap <f5> :call InputTimestamp() <CR>
    "Operation for git
    noremap <f1> :Git add .<cr>
    noremap <f2> :Git commit -m "update"<cr>
    noremap ,<f3> :Git push -u origin master<cr>
    noremap <f4> :Git status<cr>
    noremap ,<f1> :Git pull origin master<cr>
endf
autocmd BufRead *.txt call SetTxtMap()

"Post my blog
autocmd BufWrite *.md noremap ,<f3> :!hexo g -d<cr>

"Fast write
imap w/ <esc>:w!<cr>

"Line feed
nmap j gj
nmap k gk

"Set YouCompleteMe
"let g:ycm_global_ycm_extra_conf = "~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py"
let g:ycm_min_num_of_chars_for_completion = 2
let g:ycm_auto_trigger = 1
let g:ycm_warning_symbol = '>'
set completeopt-=preview
"let g:ycm_add_preview_to_completeopt = 0
"let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_echo_current_diagnostic = 1
let g:ycm_enable_diagnostic_signs = 0
"let g:ycm_show_diagnostics_ui = 1
"let g:ycm_always_populate_location_list = 0
"let g:ycm_open_loclist_on_ycm_diags = 1
"let g:ycm_always_changing_updatetime = 1
let g:ycm_complete_in_comments = 0
let g:ycm_complete_in_strings = 1
let g:ycm_collect_identifiers_from_files = 0

nnoremap ,dc :YcmCompleter GoToDeclaration<CR>
nnoremap ,df :YcmCompleter GoToDefinition<CR>
nnoremap ,dd :YcmCompleter GoToDefinitionElseDeclaration<CR>

"语法关键字补全
"let g:ycm_seed_identifiers_with_syntax=1
