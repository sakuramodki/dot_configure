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
set clipboard=unnamed
set backspace=start,eol,indent

"NeoBundle
set nocompatible               " be iMproved
filetype off

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
  call neobundle#begin(expand('~/.vim/bundle/'))
endif

NeoBundle 'tpope/vim-fugitive'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'tomasr/molokai'
NeoBundle 'Shougo/vimfiler'

NeoBundle 'itchyny/lightline.vim'
NeoBundle 'yonchu/accelerated-smooth-scroll'
"NeoBundle 'scrolloose/sytastic.git'
NeoBundle 'nathanaelkane/vim-indent-guides'

" vim-scripts repos
NeoBundle 'junegunn/vim-easy-align'

" non github repos
call neobundle#end()
NeoBundleCheck

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


nnoremap <F1> :Unite tab<Enter>
nnoremap <F2> :<C-u>VimFilerExplorer -winwidth=50<Enter>
nnoremap <F3> :tab new<Enter>:<C-u>VimFilerExplorer -winwidth=50<CR>
nnoremap <F4> :tabc<CR>

nnoremap 1 :tabn 1<CR>
nnoremap 2 :tabn 2<CR>
nnoremap 3 :tabn 3<CR>
nnoremap 4 :tabn 4<CR>
nnoremap 5 :tabn 5<CR>
nnoremap 6 :tabn 6<CR>
nnoremap 7 :tabn 7<CR>
nnoremap 8 :tabn 8<CR>
nnoremap 9 :tabn 9<CR>
nnoremap 0 :tabn 0<CR>


" 無名レジスタを使わない
xnoremap p "0p

" easy-align
vmap <Enter> <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)


" lightline.vim
let g:lightline = {
	\     'colorscheme': 'wombat',
	\     'mode_map': {'c': 'NORMAL'},
	\     'active': {
	\       'left': [ ['mode', 'paste' ], ['fugitive', 'filedir', 'filename'], ['funcname'] ]
	\     },
	\     'inactive': {
	\       'left': [ ['mode', 'paste' ], ['fugitive', 'filedir', 'filename'], ['funcname'] ]
	\     },
	\     'component_function': {
	\     'modified': 'MyModified',
	\     'readonly': 'MyReadonly',
	\     'fugitive': 'MyFugitive',
	\     'filename': 'MyFilename',
	\     'fileformat': 'MyFileformat',
	\     'filetype': 'MyFiletype',
	\     'fileencoding': 'MyFileencoding',
	\     'mode': 'MyMode',
	\     'syntastic': 'SyntasticStatuslineFlag',
	\     'gitgutter': 'MyGitGutter',
	\    }
	\}

function! MyModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &ro ? '⭤' : ''
endfunction

function! MyFilename()
  return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? substitute(b:vimshell.current_dir,expand('~'),'~','') :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  try
    if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
      let _ = fugitive#head()
      return strlen(_) ? '⭠ '._ : ''
    endif
  catch
  endtry
  return ''
endfunction

function! MyFileformat()
  return winwidth('.') > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
  return winwidth('.') > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth('.') > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
  return winwidth('.') > 60 ? lightline#mode() : ''
endfunction

function! MyGitGutter()
  if ! exists('*GitGutterGetHunkSummary')
        \ || ! get(g:, 'gitgutter_enabled', 0)
        \ || winwidth('.') <= 90
    return ''
  endif
  let symbols = [
        \ g:gitgutter_sign_added . ' ',
        \ g:gitgutter_sign_modified . ' ',
        \ g:gitgutter_sign_removed . ' '
        \ ]
  let hunks = GitGutterGetHunkSummary()
  let ret = []
  for i in [0, 1, 2]
    if hunks[i] > 0
      call add(ret, symbols[i] . hunks[i])
    endif
  endfor
  return join(ret, ' ')
endfunction





