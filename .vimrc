" Vim Env. configure
set number
set nocompatible
syntax enable
autocmd bufnewfile,bufread *.scpt,*.applescript :setl filetype=applescript
set smartindent
set tabstop=4
set shiftwidth=4
set ruler
set showmatch
set mouse=niv 
set clipboard=unnamed


"NeoBundle
set nocompatible               " be iMproved
filetype off

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
  call neobundle#rc(expand('~/.vim/bundle/'))
endif

" Vimproc
NeoBundle 'Shougo/vimproc', {
  \ 'build' : {
    \ 'windows' : 'make -f make_mingw32.mak',
    \ 'cygwin' : 'make -f make_cygwin.mak',
    \ 'mac' : 'make -f make_mac.mak',
    \ 'unix' : 'make -f make_unix.mak',
  \ },
  \ }

NeoBundle 'tpope/vim-fugitive'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'Shougo/neocomplcache'

" vim-scripts repos
NeoBundle 'rails.vim'

" non github repos

"Bundle github repos
filetype plugin indent on     " required!
filetype indent on
syntax on



"Unite.vim
 " The prefix key.
 nnoremap    [unite]   <Nop>
 nmap    <Leader>f [unite]
  
 " unite.vim keymap
 " https://github.com/alwei/dotfiles/blob/3760650625663f3b08f24bc75762ec843ca7e112/.vimrc
 nnoremap [unite]u  :<C-u>Unite -no-split<Space>
 nnoremap <silent> [unite]f :<C-u>Unite<Space>buffer<CR>
 nnoremap <silent> [unite]b :<C-u>Unite<Space>bookmark<CR>
 nnoremap <silent> [unite]m :<C-u>Unite<Space>file_mru<CR>
 nnoremap <silent> [unite]r :<C-u>UniteWithBufferDir file<CR>
 nnoremap <silent> ,vr :UniteResume<CR>
  
 " vinarise
 let g:vinarise_enable_auto_detect = 1
    
 " unite-build map
 nnoremap <silent> ,vb :Unite build<CR>
 nnoremap <silent> ,vcb :Unite build:!<CR>
 nnoremap <silent> ,vch :UniteBuildClearHighlight<CR>


 "NeoComplCache
 let g:neocomplcache_enable_at_startup = 1
nnoremap <C-v> :<C-u>registers<Enter>
