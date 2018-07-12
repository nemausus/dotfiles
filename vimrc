" Author : Naresh Kumar
" Setup steps :
" 1) Copy this file to ~/.vimrc
" 2) Configure plugin manager
"    $ git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
" 3) Install plugins by launching vim and runing :PluginInstall
" 4) Setup YouCompleteMe server
"    $ cd ~/.vim/bundle/YouCompleteMe && ./install.py --clang-completer
" 5) Setup FZF
"    $ git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install

set nocompatible             " off compatibility with vi
filetype off                 " enable it after vundle commands

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
Plugin 'gmarik/Vundle.vim'

Plugin 'Valloric/YouCompleteMe'
Plugin 'airblade/vim-gitgutter'
Plugin 'altercation/vim-colors-solarized'
Plugin 'junegunn/fzf.vim'
Plugin 'nemausus/vim-copyright'
Plugin 'nemausus/vim-headerguard'
Plugin 'rhysd/vim-clang-format'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'

" All of your Plugins must be added before the following line
call vundle#end()

" keyboard shortcuts added by above plugins
" vim-gitgutter
"   [c ]c : Jump between changed hunks
"   <leader>hp hs hu : preview, stage and undo chunks
"
" vim-abolish
"   crs : change to snake_case.
"   crm : change to MixedCase.
"   crc : change to camelCase.
"   cru : change to UPPER_CASE.
"   cr- : change to dash-case.
"   cr. : change to dot.case.
"   cr<space> : chage to space case.
"   crt : change to Title case.
"
" vim-surround
"   cs"' : change "hello world" to 'hello world'
"   ds"  : change "hello world" to hello world
"   yssb : surround entire line by )
"   ysiw} : surround current word by }
"
"  vim-unimpaired
"    ]c [c : Naviagte changed hunks. 
"    ]n [n : Navigate merge conflicts.
"    ]f [f : Navigate files in current directory.
"    ]q [q : Naviagte quickfix list. (:cnext :cprevious)
"    ]Q [Q :                         (:clast :cfirst)
"    ]l [l : Naviagte location list. (:lnext :lprevious)
"    ]L [L :                         (:llast :lfirst)
"    ]a [a : Navigate files from argument list. (:next :previous)
"    ]A [A :                                    (:last :first)
"    ]b [b : Naviagte buffers. (:bnext :bprevious)
"    ]B [B :                   (:blast :bfirst)
"    ]t [t : Naviagte tag list. (:tnext :tprevious)
"    ]T [T :                    (:tlast :tfirst)

" Filetype
filetype plugin indent on    " required
syntax enable                " required

" Configure ycm plugin
let g:ycm_always_populate_location_list = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_complete_in_comments = 1
let g:ycm_confirm_extra_conf = 0

" Configure solarized plugin
set background=dark
colorscheme solarized

" Configure fzf plugin
set rtp+=~/.fzf

" Indent style
set shiftwidth=2    " two spaces per indent
set tabstop=2       " number of spaces per tab in display
set softtabstop=2   " number of spaces per tab when inserting
set expandtab       " substitute spaces for tabs
set autoindent      " carry indent over to new lines

augroup indent4
  autocmd!
  autocmd Filetype python,java setlocal shiftwidth=4 tabstop=4 softtabstop=4
  autocmd Filetype java setlocal colorcolumn=101
augroup END

" Enable syntax highlighting for thirft and scons files.
autocmd BufReadPre *.thrift setlocal filetype=cpp
autocmd BufReadPre SConstruct,SConscript setlocal filetype=python

" Display
set colorcolumn=81  " mark column width to 80
set number          " show line numbers
set splitright      " open file to right in split view
set mouse=a         " set mouse scroll
set scrolloff=999   " better scrolling

" File search
set wildmode=longest,full
set wildmenu        " display all matching files on TAB
set path+=**        " find file recursively

" Text search.
set hlsearch        " highlight search
set incsearch       " search with typeahead
set ignorecase      " case insensitive search
set smartcase

set history=200     " save command history upto 200

" Disable some features 
set nobackup
set nowritebackup
set noswapfile
set nomodeline
set belloff=all     " no bells in terminal

" Enable filtering in command mode when going through history
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" Better navigation between windows
noremap <C-h> <C-w><C-h>
noremap <C-j> <C-w><C-j>
noremap <C-k> <C-w><C-k>
noremap <C-l> <C-w><C-l>

" Custom commands
command! -nargs=0 Stest execute 'vert ter scons -j20 runtests=default %:h:%:t:r'
command! -nargs=0 Sopt execute 'vert ter scons mode=opt -j20 runtests=default %:h:%:t:r'
command! -nargs=0 Sdbg execute 'vert ter scons mode=dbg -j20 runtests=default %:h:%:t:r'

" Search for visual selection using * and #
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>
function! <SID>VSetSearch()
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

" Remove any trailing whitespace on save.
function! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfu
autocmd FileType
  \ c,cpp,haskell,java,javascript,php,python,ruby,thrift,proto,typescript
  \ autocmd BufWritePre <buffer>
  \ :call <SID>StripTrailingWhitespaces()

" Jump to address
function! <SID>GoToAddress()
  let addr=matchstr(getline("."), '0x\x\+')
  if empty(addr)
    let addr="0x".matchstr(getline("."), '\x\+')
  endif
  let outfile=bufname("%")
  let binary=strpart(outfile, 0, strlen(outfile) - 7)
  let line=system("addr2line -e ".binary." ".addr)
  let file=split(split(line)[0], ":")
  silent execute ':vs +'.file[1]." ".file[0]
  echom line
endfunction

" Custom mappings
let mapleader = ","
noremap  <leader>/ :nohlsearch<CR>
noremap  <leader>a :call <SID>GoToAddress()<CR>
noremap  <leader>b :Buffers<CR>
noremap  <leader>c :normal 0i//<CR>
noremap  <leader>e :e %:h<CR>
noremap  <leader>f :GFiles<CR>
noremap  <leader>g mG :Ggrep <C-r><C-w> 
noremap  <leader>h :e %:r.hpp<CR>
noremap  <leader>k :ClangFormat<CR>
noremap  <leader>l :Lines<CR>
noremap  <leader>p "ap
noremap  <leader>q :BTags<CR>
noremap  <leader>s :e %:r.cpp<CR>
noremap  <leader>t :Tags<CR>
noremap  <leader>u :s/^\s*\/\///<CR>
noremap  <leader>v :vs %:h<CR>
noremap  <leader>w <C-w>W
noremap  <leader>y "ay
noremap  <leader>yf :YcmCompleter FixIt<CR>
noremap  <leader>yg :YcmCompleter GoToDeclaration<CR>
noremap  <leader>yt :YcmCompleter GetType<CR>
noremap  <leader>z va}zf
