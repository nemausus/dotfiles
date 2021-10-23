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

Plugin 'christoomey/vim-tmux-navigator'
Plugin 'airblade/vim-gitgutter'
Plugin 'altercation/vim-colors-solarized'
Plugin 'junegunn/fzf.vim'
Plugin 'jesseleite/vim-agriculture'
Plugin 'lyuts/vim-rtags'
Plugin 'nemausus/vim-copyright'
Plugin 'nemausus/vim-headerguard'
Plugin 'nemausus/vim-log-syntax'
Plugin 'nemausus/vim-scons'
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

source $LOCAL_ADMIN_SCRIPTS/master.vimrc
source $LOCAL_ADMIN_SCRIPTS/vim/filetype.vim

let repo_path = system('hg root')
let repo_initial = 'f'
if repo_path =~# 'configerator'
    let repo_initial = 'c'
elseif repo_path =~# 'www'
    let repo_initial = 't'
elseif repo_path =~# 'fbcode'
    let repo_initial = 'f'
endif

command! -bang -nargs=* Bg
  \ call fzf#vim#grep(
  \   repo_initial . 'bgs --color=on '.shellescape(<q-args>) .
  \ '| sed "s,^[^/]*/,,"' .
  \ '| sed "s#^#$(hg root)/#g"', 1,
  \   fzf#vim#with_preview('up:60%'),
  \   <bang>0)

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

" Configure rtags plugin
let g:rtagsRdmCmd = "~/rtags/bin/rdm"
let g:rtagsRcCmd = "~/rtags/bin/rc"
let g:rtagsUseLocationList = 0
let g:rtagsAutoLaunchRdm = 1

" Configure solarized plugin
set background=dark
colorscheme solarized

" Configure fzf plugin
set rtp+=~/.fzf
set rtp+=/usr/local/opt/fzf

" Configure copyright plugin
let g:copyright_company_name = "Thoughtspot Inc"

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
set scrolloff=999   " better scrolling.

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
function! StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfu
autocmd FileType
  \ c,cpp,haskell,java,javascript,php,python,ruby,thrift,proto,typescript
  \ autocmd BufWritePre <buffer>
  \ :call StripTrailingWhitespaces()

" Close split above
function! CloseAbove()
  let pos = win_screenpos(winnr())
  if pos[0] != 1
    execute "normal!  \<C-w>\<C-k>\<C-w>q"
  endif
endfunction

" Jump to address
function! GoToAddress()
  call CloseAbove()
  let addr=matchstr(getline("."), '0x\x\+')
  if empty(addr)
    let addr="0x".matchstr(getline("."), '\x\+')
  endif
  let outfile=bufname("%")
  let binary=strpart(outfile, 0, strlen(outfile) - 7)
  let line=system("addr2line -e ".binary." ".addr)
  let file=split(split(line)[0], ":")
  silent execute ':sp +'.file[1]." ".file[0]
  execute "normal!  \<C-w>\<C-j>"
  echom line
endfunction

function! OpenFile(file)
  if bufexists(a:file)
    exe 'buffer '.a:file
  endif
  exe 'e '.a:file
endfunction

" Toggle between header and source file.
function! ToggelCpp()
  let file=expand('%:p')
  let ext=expand('%:t:e')
  let prefix=strpart(file, 0, strlen(file) - strlen(ext))
  let header = ['hpp', 'h']
  let source = ['cpp', 'cc', 'c']
  let dest = []
  if index(header, ext) != -1
    let dest = source
  elseif index(source, ext) != -1
    let dest = header
  endif
  for e in dest
    if filereadable(prefix.e)
      call OpenFile(prefix.e)
    endif
  endfor
endfunction

function! GotoTarget()
  let tp = findfile("TARGETS", ".;")
  if tp == ""
    echo "TARGETS Not Found"
  else
    exe "vsplit " . tp
  endif
endfunction
command! GotoTarget call GotoTarget()

" Custom mappings
let mapleader = ","

noremap <leader>/ :nohlsearch<CR>
noremap <leader>a :call GoToAddress()<CR>
noremap <leader>b :Buffers<CR>
noremap <leader>bg mG :Bg <C-r><C-w><CR>
noremap <leader>c :normal 0i//<CR>
noremap <leader>e :e %:h<CR>
let g:wd = ""
noremap <leader>f :execute 'Files '.g:wd<CR>
let g:agriculture#disable_smart_quoting = 1
noremap <leader>g mG :RgRaw TERM DIR
noremap <leader>h :call ToggelCpp()<CR>
noremap <leader>k :ClangFormat<CR>
noremap <leader>l :Lines<CR>
noremap <leader>p "ap
noremap <leader>q :BTags<CR>
noremap <leader>t :Tags<CR>
noremap <leader>u :s/^\s*\/\///<CR>
noremap <leader>v :vs %:h<CR>
noremap <leader>w <C-w>W
noremap <leader>x :call CloseAbove()<CR>
noremap <leader>y "ay
noremap <leader>yf :YcmCompleter FixIt<CR>
noremap <leader>yg :YcmCompleter GoToDeclaration<CR>
noremap <leader>yt :YcmCompleter GetType<CR>
noremap <leader>z va}zf
